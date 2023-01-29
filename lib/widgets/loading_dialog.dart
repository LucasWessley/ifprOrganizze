import 'package:flutter/material.dart';


class LoadingDialogWidget extends StatelessWidget {
  final String? massage;

  LoadingDialogWidget({
    this.massage,
});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [


          //COR DO PROGRESS
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 14),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.red),
            ),
          ),


          Text(
            massage.toString() +", aguarde...",
          ),

        ],
      ),
    );
  }
}
