part of '../firelamp_in_app_purchase.dart';

class PurchaseHistory {
  PurchaseHistory({
    this.id,
    this.userId,
    this.stamp,
    this.status,
    this.productDetailsId,
    this.productDetailsTitle,
    this.productDetailsDescription,
    this.productDetailsPrice,
    this.productDetailsSkProductPrice,
    this.productDetailsSkProductPriceLocaleCurrencyCode,
    this.productDetailsSkProductPriceLocaleCurrencySymbol,
    this.productDetailsSkProductProductIdentifier,
    this.purchaseDetailsProductId,
    this.purchaseDetailsPendingCompletePurchase,
    this.purchaseDetailsVerificationDataLocalVerificationData,
    this.purchaseDetailsVerificationDataServerVerificationData,
    this.purchaseDetailsSkPaymentTransactionTransactionIdentifier,
    this.purchaseDetailsTransactionDate,
    this.purchaseDetailsPurchaseId,
    this.purchaseDetailsPrice,
    this.purchaseDetailsSkPaymentTransactionTransactionTimeStamp,
    this.purchaseDetailsSkPaymentTransactionPaymentProductIdentifier,
    this.purchaseDetailsSkPaymentTransactionPaymentQuantity,
  });

  String id;
  String userId;
  String stamp;
  String status;
  String productDetailsId;
  String productDetailsTitle;
  String productDetailsDescription;
  String productDetailsPrice;
  String productDetailsSkProductPrice;
  String productDetailsSkProductPriceLocaleCurrencyCode;
  String productDetailsSkProductPriceLocaleCurrencySymbol;
  String productDetailsSkProductProductIdentifier;
  String purchaseDetailsProductId;
  String purchaseDetailsPendingCompletePurchase;
  String purchaseDetailsVerificationDataLocalVerificationData;
  String purchaseDetailsVerificationDataServerVerificationData;
  String purchaseDetailsSkPaymentTransactionTransactionIdentifier;
  String purchaseDetailsTransactionDate;
  String purchaseDetailsPurchaseId;
  String purchaseDetailsPrice;
  String purchaseDetailsSkPaymentTransactionTransactionTimeStamp;
  String purchaseDetailsSkPaymentTransactionPaymentProductIdentifier;
  String purchaseDetailsSkPaymentTransactionPaymentQuantity;

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) => PurchaseHistory(
        id: json["ID"].toString(),
        userId: json["user_ID"].toString(),
        stamp: json["stamp"].toString(),
        status: json["status"].toString(),
        productDetailsId: json["productDetails_id"].toString(),
        productDetailsTitle: json["productDetails_title"].toString(),
        productDetailsDescription: json["productDetails_description"].toString(),
        productDetailsPrice: json["productDetails_price"].toString(),
        productDetailsSkProductPrice: json["productDetails_skProduct_price"].toString(),
        productDetailsSkProductPriceLocaleCurrencyCode:
            json["productDetails_skProduct_priceLocale_currencyCode"].toString(),
        productDetailsSkProductPriceLocaleCurrencySymbol:
            json["productDetails_skProduct_priceLocale_currencySymbol"].toString(),
        productDetailsSkProductProductIdentifier:
            json["productDetails_skProduct_productIdentifier"].toString(),
        purchaseDetailsProductId: json["purchaseDetails_productID"].toString(),
        purchaseDetailsPendingCompletePurchase:
            json["purchaseDetails_pendingCompletePurchase"].toString(),
        purchaseDetailsVerificationDataLocalVerificationData:
            json["purchaseDetails_verificationData_localVerificationData"].toString(),
        purchaseDetailsVerificationDataServerVerificationData:
            json["purchaseDetails_verificationData_serverVerificationData"].toString(),
        purchaseDetailsSkPaymentTransactionTransactionIdentifier:
            json["purchaseDetails_skPaymentTransaction_transactionIdentifier"].toString(),
        purchaseDetailsTransactionDate: json["purchaseDetails_transactionDate"].toString(),
        purchaseDetailsPurchaseId: json["purchaseDetails_purchaseID"].toString(),
        purchaseDetailsPrice: json["purchaseDetails_price"].toString(),
        purchaseDetailsSkPaymentTransactionTransactionTimeStamp:
            json["purchaseDetails_skPaymentTransaction_transactionTimeStamp"].toString(),
        purchaseDetailsSkPaymentTransactionPaymentProductIdentifier:
            json["purchaseDetails_skPaymentTransaction_payment_productIdentifier"].toString(),
        purchaseDetailsSkPaymentTransactionPaymentQuantity:
            json["purchaseDetails_skPaymentTransaction_payment_quantity"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "user_ID": userId,
        "stamp": stamp,
        "status": status,
        "productDetails_id": productDetailsId,
        "productDetails_title": productDetailsTitle,
        "productDetails_description": productDetailsDescription,
        "productDetails_price": productDetailsPrice,
        "productDetails_skProduct_price": productDetailsSkProductPrice,
        "productDetails_skProduct_priceLocale_currencyCode":
            productDetailsSkProductPriceLocaleCurrencyCode,
        "productDetails_skProduct_priceLocale_currencySymbol":
            productDetailsSkProductPriceLocaleCurrencySymbol,
        "productDetails_skProduct_productIdentifier": productDetailsSkProductProductIdentifier,
        "purchaseDetails_productID": purchaseDetailsProductId,
        "purchaseDetails_pendingCompletePurchase": purchaseDetailsPendingCompletePurchase,
        "purchaseDetails_verificationData_localVerificationData":
            purchaseDetailsVerificationDataLocalVerificationData,
        "purchaseDetails_verificationData_serverVerificationData":
            purchaseDetailsVerificationDataServerVerificationData,
        "purchaseDetails_skPaymentTransaction_transactionIdentifier":
            purchaseDetailsSkPaymentTransactionTransactionIdentifier,
        "purchaseDetails_transactionDate": purchaseDetailsTransactionDate,
        "purchaseDetails_purchaseID": purchaseDetailsPurchaseId,
        "purchaseDetails_price": purchaseDetailsPrice,
        "purchaseDetails_skPaymentTransaction_transactionTimeStamp":
            purchaseDetailsSkPaymentTransactionTransactionTimeStamp,
        "purchaseDetails_skPaymentTransaction_payment_productIdentifier":
            purchaseDetailsSkPaymentTransactionPaymentProductIdentifier,
        "purchaseDetails_skPaymentTransaction_payment_quantity":
            purchaseDetailsSkPaymentTransactionPaymentQuantity,
      };
}
