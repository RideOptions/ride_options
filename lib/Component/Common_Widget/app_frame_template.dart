import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppFrameTemplate extends StatelessWidget {
  double? cornerRadius;
  Widget customWidget;

  AppFrameTemplate({this.cornerRadius=5.0, required this.customWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ), //BoxShadow
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius!)),
      ),
      child: customWidget,

    );
  }
}
