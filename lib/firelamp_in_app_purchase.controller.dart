part of 'firelamp_in_app_purchase.dart';

class SessionStatus {
  static final String pending = 'pending';
  static final String success = 'success';
  static final String failure = 'failure';
}

class FirelampInAppPurchase {
  /// Singleton
  static FirelampInAppPurchase _instance;
  static FirelampInAppPurchase get instance {
    if (_instance == null) {
      _instance ??= FirelampInAppPurchase();
    }
    return _instance;
  }

  Map<String, ProductDetails> products = {};
  List<String> missingIds = [];
  Set<String> _productIds = {};

  /// [productReady] is being fired after it got product list from the server.
  /// The app can display product after this event.
  BehaviorSubject productReady = BehaviorSubject.seeded(null);

  /// On `android` you need to specify which is consumable. By listing the product ids
  List consumableIds = [];

  /// It autoconsume the consumable product by default.
  /// If you set it to false, you must manually mark the product as consumed to enable another purchase (Android only).
  bool autoConsume;

  /// [pending] event will be fired on incoming purchases or previous purchase of previous app session.
  ///
  /// The app can show a UI to display the payment is on going.
  ///
  /// Note that [pending] is `PublishSubject`. This means, the app must listen [pending] before invoking `init()`
  // ignore: close_sinks
  PublishSubject pending = PublishSubject<PurchaseDetails>();

  /// [error] event will be fired when any of purchase fails(or errors). This
  /// includes cancellation, verification failure, and other errors.
  ///
  /// Note that [error] is `PublishSubject`. This means, the app must listen [error] before invoking `init()`
  // ignore: close_sinks
  PublishSubject error = PublishSubject<PurchaseDetails>();

  /// [success] event will be fired after the purchase has made and the the app can
  /// deliver the purchase to user.
  ///
  /// Not that the app can then, connect to backend server to verifiy if the
  /// payment was really made and deliver products to user on the backend.
  ///
  /// Note that, the event data of [success] is `PurchaseDetails`
  ///
  // ignore: close_sinks
  PublishSubject<PurchaseDetails> success = PublishSubject<PurchaseDetails>();

  StreamSubscription<List<PurchaseDetails>> _subscription;

  InAppPurchaseConnection connection = InAppPurchaseConnection.instance;

  ProductDetails lastSelectedProduct;

  FirelampInAppPurchase() {
    // final Stream purchaseUpdates = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    // _subscription = purchaseUpdates.listen((purchases) {
    //   _listenToPurchaseUpdated(purchases);
    // });
  }

  /// Initialize payment
  ///
  /// Attention, [init] should be called after Firebase initialization since
  /// it may access database for pending purchase from previous app session.
  init({
    Set<String> productIds,
    List<String> consumableIds,
    bool autoConsume = true,
  }) {
    // print('Payment::init');
    this._productIds = productIds;
    this.consumableIds = consumableIds;
    this.autoConsume = autoConsume;
    _initIncomingPurchaseStream();
    _initPayment();
  }

  /// Subscribe to any incoming(or pending) purchases
  ///
  /// It's important to listen as soon as possible to avoid losing events.
  _initIncomingPurchaseStream() {
    /// Listen to any pending & incoming purchases.
    ///
    /// If app crashed right after purchase but the purchase has not yet
    /// delivered, then, the purchase will be notified here with
    /// `PurchaseStatus.pending`. This is confirmed on iOS.
    ///
    /// Note, that this listener will be not unscribed since it should be
    /// lifetime listener
    ///
    /// Note, for the previous app session pending purchase, listener event will be called
    /// one time only on app start after closing. Hot-Reload or Full-Reload is not working.
    connection.purchaseUpdatedStream.listen((dynamic purchaseDetailsList) {
      print('purchaseUpdatedStream.listen( ${purchaseDetailsList.length} )');
      purchaseDetailsList.forEach(
        (PurchaseDetails purchaseDetails) async {
          print('purchaseDetailsList.forEach( ... )');
          // All purchase event(pending, success, or cancelling) comes here.

          // if it's pending, this mean, the user just started to pay.
          // previous app session pending purchase is not `PurchaseStatus.pending`. It is either
          // `PurchaseStatus.purchased` or `PurchaseStatus.error`
          if (purchaseDetails.status == PurchaseStatus.pending) {
            print('=> pending on purchaseUpdatedStream');
            print(purchaseDetails.toString());
            pending.add(purchaseDetails);
            _recordPending(purchaseDetails);
          } else if (purchaseDetails.status == PurchaseStatus.error) {
            print('=> error on purchaseUpdatedStream');
            print(purchaseDetails.toString());
            error.add(purchaseDetails);
            _recordFailure(purchaseDetails);
            if (Platform.isIOS) {
              connection.completePurchase(purchaseDetails);
            }
          } else if (purchaseDetails.status == PurchaseStatus.purchased) {
            print('=> purchased on purchaseUpdatedStream');
            print(purchaseDetails.toString());

            /// verify purchase
            dynamic dataModel = await _verifyPurchase(purchaseDetails);

            // for android & consumable product only.
            if (Platform.isAndroid) {
              if (!autoConsume && consumableIds.contains(purchaseDetails.productID)) {
                await connection.consumePurchase(purchaseDetails);
              }
            }

            if (purchaseDetails.pendingCompletePurchase) {
              await connection.completePurchase(purchaseDetails);
              // await _recordSuccess(purchaseDetails);
              success.add(purchaseDetails);
            }
          }
        },
      );
    }, onDone: () {
      // @todo post an event of 'done'
      print('onDone:');
    }, onError: (error) {
      // @todo post an event of 'error'
      print('onError: error on listening:');
      print(error);
    });
  }

  _initPayment() async {
    final bool available = await connection.isAvailable();

    if (available) {
      ProductDetailsResponse response = await connection.queryProductDetails(_productIds);

      /// Check if any of given product id(s) are missing.
      if (response.notFoundIDs.isNotEmpty) {
        missingIds = response.notFoundIDs;
      }

      response.productDetails.forEach((product) => products[product.id] = product);

      print('iap products: $products');

      productReady.add(products);
    } else {
      print('===> InAppPurchase connection is NOT avaible!');
    }
  }

  _recordPending(PurchaseDetails purchaseDetails) async {
    if (Platform.isIOS && purchaseDetails?.verificationData == null) {
      // todo On iOS, this may be null. Call [InAppPurchaseConnection.refreshPurchaseVerificationData] to get a new [PurchaseVerificationData] object for further validation.
    }
    print('psending data:');
    print(purchaseDetails);
    // print(jsonEncode(data));
    await recordFailurePurchase(getData(purchaseDetails));
  }

  _recordFailure(PurchaseDetails purchaseDetails) async {
    print('_recordFailure');
    print(purchaseDetails);
    await recordFailurePurchase(getData(purchaseDetails));
  }

  Future buyConsumable(ProductDetails product) async {
    lastSelectedProduct = product;
    PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
    );

    await connection.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }

  getData(PurchaseDetails purchaseDetails) {
    String productId =
        purchaseDetails?.productID != null ? purchaseDetails?.productID : lastSelectedProduct.id;
    ProductDetails productDetails = products[productId];
    final Map<String, dynamic> data = {
      'productID': productDetails.id,
      'purchaseID': purchaseDetails?.purchaseID,
      'price': productDetails?.price,
      'title': productDetails?.title,
      'description': productDetails?.description,
      'transactionDate': purchaseDetails?.transactionDate,
      'localVerificationData': purchaseDetails?.verificationData?.localVerificationData,
      'serverVerificationData': purchaseDetails?.verificationData?.serverVerificationData,
    };

    if (purchaseDetails?.verificationData?.source == IAPSource.AppStore) {
      data['platform'] = 'ios';
    } else if (purchaseDetails?.verificationData?.source == IAPSource.GooglePlay) {
      data['platform'] = 'android';
    } else {
      if (Platform.isIOS) {
        data['platform'] = 'ios';
      } else if (Platform.isAndroid) {
        data['platform'] = 'android';
      }
    }

    // Android has no skPaymentTransaction
    if (purchaseDetails.skPaymentTransaction != null) {
      data['applicationUsername'] =
          purchaseDetails.skPaymentTransaction?.payment?.applicationUsername;
      data['productIdentifier'] = purchaseDetails.skPaymentTransaction?.payment?.productIdentifier;
      data['quantity'] = purchaseDetails.skPaymentTransaction?.payment?.quantity;
      data['transactionIdentifier'] = purchaseDetails.skPaymentTransaction?.transactionIdentifier;
      data['transactionTimeStamp'] = purchaseDetails.skPaymentTransaction?.transactionTimeStamp;
    }

    return data;
  }

  Future<dynamic> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return requestVerification(getData(purchaseDetails));
  }

  Future<dynamic> requestVerification(Map<String, dynamic> data) async {
    data['route'] = 'in-app-purchase.verifyPurchase';
    try {
      final re = await Api.instance.request(data);
      print(re);
      return re;
    } catch (e) {
      print('e: $e');
    }
  }

  recordFailurePurchase(Map<String, dynamic> data) {
    data['route'] = 'in-app-purchase.recordFailure';
    return Api.instance.request(data);
  }

  recordPendingPurchase(Map<String, dynamic> data) {
    data['route'] = 'in-app-purchase.recordPending';
    return Api.instance.request(data);
  }

  recordSuccessPurchase(Map<String, dynamic> data) {
    data['route'] = 'in-app-purchase.recordSuccess';
    return Api.instance.request(data);
  }

  /// Returns the Collection Query to get the login user's success purchases.
  Future<List<PurchaseHistory>> get getMyPurchases async {
    final List<dynamic> res = await Api.instance.request({'route': 'in-app-purchase.myPurchase'});
    List<PurchaseHistory> purchaseHistory = [];
    for (int i = 0; i < res.length; i++) {
      purchaseHistory.add(PurchaseHistory.fromJson(res[i]));
    }
    return purchaseHistory;
  }
}
