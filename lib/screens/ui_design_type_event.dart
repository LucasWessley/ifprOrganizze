import 'package:flutter/material.dart';
import 'package:organizze_moderator/itens_screens/item_screen.dart';
import 'package:organizze_moderator/models/type_events.dart';


class TypeEventDesignWidget extends StatefulWidget {

  TypeEvent? model;
  BuildContext? context;

  TypeEventDesignWidget({this.context, this.model});


  @override
  State<TypeEventDesignWidget> createState() => _TypeEventDesignWidgetState();
}

class _TypeEventDesignWidgetState extends State<TypeEventDesignWidget> {
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
                    IconButton(onPressed: (){}, icon: Icon(Icons.delete_sweep,
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
