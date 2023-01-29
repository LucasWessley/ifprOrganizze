import 'package:flutter/material.dart';


class CustomTextField extends StatefulWidget
{
  TextEditingController? textEditingController;
  IconData? iconData;
  String? hintText;
  bool? isObscure = true;
  bool? enable = true;

  CustomTextField({
    this.textEditingController,
    this.iconData,
    this.hintText,
    this.isObscure,
    this.enable,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}



class _CustomTextFieldState extends State<CustomTextField>
{
  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: widget.enable,
        controller: widget.textEditingController,
        obscureText: widget.isObscure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.iconData,
            color: Colors.black,
            size: 22,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
























// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatefulWidget {
//   TextEditingController? textEditingController;
//   IconData? iconData;
//   String? hintText;
//   bool? isObscure = true;
//   bool? enable = true;
//
//   CustomTextField({
//     this.textEditingController,
//     this.iconData,
//     this.hintText,
//     this.isObscure,
//     this.enable,
//   });
//
//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<CustomTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//       // padding: EdgeInsets.all(8.0),
//       margin: EdgeInsets.all(8.0),
//       child: TextFormField(
//         enabled: widget.enable,
//         controller: widget.textEditingController,
//         obscureText: widget.isObscure!,
//         cursorColor: Colors.black,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(20),
//             ),
//           ),
//           prefix: Padding(
//             padding: const EdgeInsets.all(1),
//             child: Icon(
//               widget.iconData,
//               color: Colors.black,
//             ),
//           ),
//           // focusColor: Theme.of(context).primaryColor,
//           hintText: widget.hintText,
//         ),
//       ),
//     );
//   }
// }
