import 'package:flutter/material.dart';

import '../theme/text_style_theme.dart';

Widget buttonWidget({
  required BuildContext context,
  required String text,
  required Function() onPress,
  double? height,
  required Color color,
  double? width,
}) {
  return Container(
    width: width ?? MediaQuery.of(context).size.width,
    height: height ?? 45,
    padding: EdgeInsets.all(0),
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: onPress,
        child: Text(
          text,
          style: whiteTextRegularIn16px(),
        )),
  );
}

Widget whiteButtonWidget({
  required BuildContext context,
  required String text,
  required Function() onPress,
  double? height,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: height ?? 45,
    padding: EdgeInsets.all(0),
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: onPress,
        child: Text(
          text,
          style: primaryTextRegularIn14px(),
        )),
  );
}

Widget redButtonWidget({
  required BuildContext context,
  required String text,
  required Function() onPress,
  double? height,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: height ?? 45,
    padding: EdgeInsets.all(0),
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: onPress,
        child: Text(
          text,
          style: whiteTextRegularIn16px(),
        )),
  );
}
