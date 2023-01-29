import 'package:flutter/material.dart';
import 'package:organizze_moderator/itens_screens/upload_items_screen.dart';
import 'package:organizze_moderator/models/type_events.dart';

import '../screens/upload_type_event.dart';
import '../widgets/delegate_header_widget.dart';
import '../widgets/my_drawer.dart';

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
                      MaterialPageRoute(builder: (c) => UploadItemScreen()));
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
              title: "" + widget.model!.catName.toString()),
        )],
      ),
    );
  }
}
