import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:organizze_moderator/screens/home_screen.dart';
import 'package:organizze_moderator/splashScreen/my_splash_screen.dart';

import '../global/global.dart';
import '../models/event_model.dart';

class EventDetailsScreen extends StatefulWidget {
  Event_Model? model;
  BuildContext? context;

  EventDetailsScreen({this.model});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  deleteEvent() {
    FirebaseFirestore.instance
        .collection("moderators")
        .doc(sharedPreferences!.getString("uid"))
        .collection("categories")
        .doc(widget.model!.catID)
        .collection("items")
        .doc(widget.model!.itemID)
        .delete().then((value){
          FirebaseFirestore.instance.collection("items").doc(widget.model!.itemID).delete();

          Fluttertoast.showToast(msg: "Evento foi excluído!");
          Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.green),
        ),
        title: Text(
          widget.model!.itemName.toString(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          deleteEvent();
        },
        label: Text("Deletar evento"),
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Image.network(
            widget.model!.thumbnailUrl.toString(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Text(
              widget.model!.itemName.toString() + ":",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Text(
              "Descrição: \n" + widget.model!.itemDescription.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Text(
                  "Início: \n" + widget.model!.itemDateStart.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Text(
                  "Final: \n" + widget.model!.itemDateEnd.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Text(
              "Local: " + widget.model!.itemLocal.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Text(
              "Horário: " + widget.model!.itemHour.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
