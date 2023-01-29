import 'package:flutter/material.dart';
class MyBoxDecoration extends StatefulWidget {
  const MyBoxDecoration({Key? key}) : super(key: key);

  @override
  State<MyBoxDecoration> createState() => _MyBoxDecorationState();
}

class _MyBoxDecorationState extends State<MyBoxDecoration> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: Colors.green,
      ),
    );
  }
}
