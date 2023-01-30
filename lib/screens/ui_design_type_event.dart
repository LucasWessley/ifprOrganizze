import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:organizze_moderator/itens_screens/item_screen.dart';
import 'package:organizze_moderator/models/type_events.dart';
import 'package:organizze_moderator/splashScreen/my_splash_screen.dart';

import '../global/global.dart';


class TypeEventDesignWidget extends StatefulWidget {

  TypeEvent? model;
  BuildContext? context;

  TypeEventDesignWidget({this.context, this.model});


  @override
  State<TypeEventDesignWidget> createState() => _TypeEventDesignWidgetState();
}

class _TypeEventDesignWidgetState extends State<TypeEventDesignWidget> {

  deleteTypeEvent(String catID){
    FirebaseFirestore.instance
        .collection('moderators')
        .doc(sharedPreferences!.getString("uid"))
        .collection('categories')
        .doc(catID).delete();
    
    Fluttertoast.showToast(msg: "O tipo de evento foi cancelado!");
    Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemScreen(
          model: widget.model,
        )));
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: Image.network(widget.model!.thumbnailUrl.toString(),
                  height: 270,
                  fit: BoxFit.cover,),
                ),
                SizedBox(height: 1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                    widget.model!.catName.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 3
                    ),
                    ),
                    IconButton(onPressed: (){
                      deleteTypeEvent(widget.model!.catID.toString());
                    }, icon: Icon(Icons.delete_sweep,
                    color: Colors.red,)),

                  ],
                )

              ],
            ) ,
          ),
        ),
      ),
    );
  }
}
