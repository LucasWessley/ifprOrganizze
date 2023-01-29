import 'package:cloud_firestore/cloud_firestore.dart';

class TypeEvent{
  String? catID;
  String? catName;
  String? catType;
  String? moderatorUID;
  Timestamp? publishedDate;
  String? status;
  String? thumbnailUrl;

  TypeEvent({
    this.catID,
    this.catName,
    this.catType,
    this.moderatorUID,
    this.publishedDate,
    this.status,
    this.thumbnailUrl,
});

  TypeEvent.fromJson(Map<String, dynamic> json){
    catID = json["catID"];
    catName = json["catName"];
    catType = json["catType"];
    moderatorUID = json["moderatorUID"];
    publishedDate = json["publishedDate"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}