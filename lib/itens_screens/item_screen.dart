import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:organizze_moderator/itens_screens/upload_items_screen.dart';
import 'package:organizze_moderator/models/event_model.dart';
import 'package:organizze_moderator/models/type_events.dart';

import '../global/global.dart';
import '../screens/ui_design_type_event.dart';
import '../screens/upload_type_event.dart';
import '../widgets/delegate_header_widget.dart';
import '../widgets/my_drawer.dart';
import 'item_ui_design_widget.dart';

class ItemScreen extends StatefulWidget {
  TypeEvent? model;

  ItemScreen({this.model});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Colors.green),
          ),
          title: Text(
            'Organizze',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => UploadItemScreen(
                          model: widget.model
                      )));

                },
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: 30,
                )),
          ]),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
          pinned: true,
          delegate: DelegateHeaderWidget(
              title: "->" + widget.model!.catName.toString() +"<-"),


        ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("moderators")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("categories")
                  .doc(widget.model!.catID)
                  .collection("items").orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot dataSnapshot)
              {
                if (dataSnapshot.hasData) {
                  // se existir
                  // display de categorias
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Event_Model eventModel = Event_Model.fromJson(
                        dataSnapshot.data.docs[index].data()
                        as Map<String, dynamic>,
                      );
                      return ItemUiDesignWidget(
                        context: context,
                        model: eventModel,
                      );
                    },
                    itemCount: dataSnapshot.data.docs.length,
                  );
                } else {
                  //se não existir
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('Não há eventos'),
                    ),
                  );
                }
              }),



        ],

      ),
    );
  }
}
