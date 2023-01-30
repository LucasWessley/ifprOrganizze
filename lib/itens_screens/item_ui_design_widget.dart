import 'package:flutter/material.dart';
import 'package:organizze_moderator/itens_screens/event_details_screen.dart';
import 'package:organizze_moderator/itens_screens/item_screen.dart';
import 'package:organizze_moderator/models/type_events.dart';

import '../models/event_model.dart';

class ItemUiDesignWidget extends StatefulWidget {
  Event_Model? model;
  BuildContext? context;

  ItemUiDesignWidget({this.context, this.model});

  @override
  State<ItemUiDesignWidget> createState() => _ItemUiDesignWidgetState();
}

class _ItemUiDesignWidgetState extends State<ItemUiDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => EventDetailsScreen(
              model: widget.model,
            ),
          ),
        );
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
                Text(
                  widget.model!.itemName.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 3),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Image.network(
                    widget.model!.thumbnailUrl.toString(),
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  widget.model!.itemDescription.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 3,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
