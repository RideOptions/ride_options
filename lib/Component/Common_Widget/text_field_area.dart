import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// ignore: must_be_immutable
class TextFieldArea extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  bool? isReadOnly;
  double? height;

  TextFieldArea(
      {this.hintText,
      this.controller,
      this.isReadOnly = false,
      this.height = 7});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height! * 24.0,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 8),
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
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: TextField(
        maxLines: 5,
        maxLength: 2000,
        controller: controller,
        keyboardType: TextInputType.text,
        readOnly: isReadOnly!,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: placeholderColor,
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
          ),
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
