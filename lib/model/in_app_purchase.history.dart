part of '../firelamp_in_app_purchase.dart';

class PurchaseHistory {
  PurchaseHistory({
    this.idx,
    this.userIdx,
    this.status,
    this.platform,
    this.productID,
    this.purchaseID,
    this.price,
    this.title,
    this.description,
    this.applicationUsername,
    this.transactionDate,
    this.productIdentifier,
    this.quantity,
    this.transactionIdentifier,
    this.transactionTimeStamp,
    this.localVerificationData,
    this.serverVerificationData,
    this.localVerificationData_packageName,
    this.createdAt,
    this.updatedAt,
  });

  String idx;
  String userIdx;
  String status;
  String platform;
  String productID;
  String purchaseID;
  String price;
  String title;
  String description;
  String applicationUsername;
  String transactionDate;
  String productIdentifier;
  String quantity;
  String transactionIdentifier;
  String transactionTimeStamp;
  String localVerificationData;
  String serverVerificationData;
  String localVerificationData_packageName;
  String createdAt;
  String updatedAt;

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) => PurchaseHistory(
        idx: json["idx"],
        userIdx: json["userIdx"],
        status: json["status"],
        platform: json["platform"],
        productID: json["productID"],
        purchaseID: json["purchaseID"],
        price: json["price"],
        title: json["title"],
        description: json["description"],
        applicationUsername: json["applicationUsername"],
        transactionDate: json["transactionDate"],
        productIdentifier: json["productIdentifier"],
        quantity: json["quantity"],
        transactionIdentifier: json["transactionIdentifier"],
        transactionTimeStamp: json["transactionTimeStamp"],
        localVerificationData: json["localVerificationData"],
        serverVerificationData: json["serverVerificationData"],
        localVerificationData_packageName: json["localVerificationData_packageName"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "userIdx": userIdx,
        "status": status,
        "platform": platform,
        "productID": productID,
        "purchaseID": purchaseID,
        "price": price,
        "title": title,
        "description": description,
        "applicationUsername": applicationUsername,
        "transactionDate": transactionDate,
        "productIdentifier": productIdentifier,
        "quantity": quantity,
        "transactionIdentifier": transactionIdentifier,
        "transactionTimeStamp": transactionTimeStamp,
        "localVerificationData": localVerificationData,
        "serverVerificationData": serverVerificationData,
        "localVerificationData_packageName": localVerificationData_packageName,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
