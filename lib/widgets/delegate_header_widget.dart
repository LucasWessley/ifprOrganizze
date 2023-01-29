import 'package:flutter/material.dart';



class DelegateHeaderWidget extends SliverPersistentHeaderDelegate {

  String? title;
  DelegateHeaderWidget({this.title});



  @override
  Widget build(BuildContext context, double shrinkOffSet, bool overlapsContent ) {
    return InkWell(
      child: Container(
        color: Colors.indigoAccent,
        height: 82,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: InkWell(
          child: Text(title.toString(),
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 3,
              color: Colors.black,
          ),),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  // MAXIMO DE ALTURA DO CONTAINER DA CATEGORIA
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  // MINIMO DE ALTURA DO CONTAINER DA CATEGORIA
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

}
