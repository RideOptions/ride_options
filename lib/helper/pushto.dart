import 'package:flutter/material.dart';

void openScreen(BuildContext context, Widget screen){
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}
void openScreenAndCloseOther(BuildContext context, Widget screen){
  Navigator.popUntil(context, (route) => false);
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}