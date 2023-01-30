import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organizze_moderator/global/global.dart';
import 'package:organizze_moderator/models/type_events.dart';
import 'package:organizze_moderator/screens/ui_design_type_event.dart';
import 'package:organizze_moderator/screens/upload_type_event.dart';
import 'package:organizze_moderator/widgets/delegate_header_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.green),
        ),
        title: Text(
          "Organizze",
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
                    MaterialPageRoute(builder: (c) => UploadTypeEvent()));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              )),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SliverPersistentHeader(
          //   pinned: true,
          //   delegate: DelegateHeaderWidget(title: "Categorias"),
          // ),

          // ESCREVER A QUERY

          //MODELO

          // DESIGN WIDGET

          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('moderators')
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("categories").orderBy("publishedDate", descending: true)
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
                      TypeEvent typeModel = TypeEvent.fromJson(
                        dataSnapshot.data.docs[index].data()
                            as Map<String, dynamic>,
                      );
                      return TypeEventDesignWidget(
                        context: context,
                        model: typeModel,
                      );
                    },
                    itemCount: dataSnapshot.data.docs.length,
                  );
                } else {
                  //se não existir
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('Não há categorias'),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
