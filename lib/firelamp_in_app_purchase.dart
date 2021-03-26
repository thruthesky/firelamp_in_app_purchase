library firelamp_in_app_purchase;

import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

class FirelampInAppPurchase {
  /// Singleton
  static FirelampInAppPurchase _instance;
  static FirelampInAppPurchase get instance {
    if (_instance == null) {
      _instance ??= FirelampInAppPurchase();
    }
    return _instance;
  }

  StreamSubscription<List<PurchaseDetails>> _subscription;
  FirelampInAppPurchase() {
    final Stream purchaseUpdates = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _listenToPurchaseUpdated(purchases);
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    // purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    //   if (purchaseDetails.status == PurchaseStatus.pending) {
    //     showPendingUI();
    //   } else {
    //     if (purchaseDetails.status == PurchaseStatus.error) {
    //       handleError(purchaseDetails.error!);
    //     } else if (purchaseDetails.status == PurchaseStatus.purchased) {
    //       bool valid = await _verifyPurchase(purchaseDetails);
    //       if (valid) {
    //         deliverProduct(purchaseDetails);
    //       } else {
    //         _handleInvalidPurchase(purchaseDetails);
    //         return;
    //       }
    //     }
    //     if (Platform.isAndroid) {
    //       if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
    //         await InAppPurchaseConnection.instance
    //             .consumePurchase(purchaseDetails);
    //       }
    //     }
    //     if (purchaseDetails.pendingCompletePurchase) {
    //       await InAppPurchaseConnection.instance
    //           .completePurchase(purchaseDetails);
    //     }
    //   }
    // });
  }
}
