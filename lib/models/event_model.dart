import 'package:cloud_firestore/cloud_firestore.dart';

class Event_Model {
  String? itemName;
  String? itemDateStart;
  String? itemDateEnd;
  String? itemLocal;
  String? itemHour;
  String? itemDuration;
  String? thumbnailUrl;
  String? status;
  String? moderatorName;
  String? moderatorUID;
  String? catID;
  String? itemID;
  Timestamp? publishedDate;
  String? itemDescription;

  Map<String, dynamic> toMap() {
    return {
      'itemName': this.itemName,
      'itemDateStart': this.itemDateStart,
      'itemDateEnd': this.itemDateEnd,
      'itemLocal': this.itemLocal,
      'itemHour': this.itemHour,
      'itemDuration': this.itemDuration,
      'thumbnailUrl': this.thumbnailUrl,
      'status': this.status,
      'moderatorName': this.moderatorName,
      'moderatorUID': this.moderatorUID,
      'catID': this.catID,
      'itemID': this.itemID,
      'publishedDate': this.publishedDate,
      'itemDescription' : this.itemDescription,
    };
  }

  Event_Model(
      this.itemName,
      this.itemDateStart,
      this.itemDateEnd,
      this.itemLocal,
      this.itemHour,

      this.itemDuration,
      this.thumbnailUrl,
      this.status,
      this.moderatorName,
      this.moderatorUID,
      this.catID,
      this.itemID,
      this.publishedDate);

  Event_Model.fromJson(Map<String, dynamic> json) {
    itemName = json["itemName"];
    itemDateStart = json["itemDateStart"];
    itemDateEnd = json["itemDateEnd"];
    itemLocal = json["itemLocal"];
    itemHour = json["itemHour"];
    itemDuration = json["itemDuration"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    moderatorName = json["moderatorName"];
    moderatorUID = json["moderatorUID"];
    catID = json["catID"];
    itemID = json["itemID"];
    publishedDate = json["publishedDate"];
    itemDescription = json["itemDescription"];
  }
}
