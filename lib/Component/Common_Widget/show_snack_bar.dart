
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,String message){
  var snackBar = SnackBar(
    content: Text(message),
    // backgroundColor: Const,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}