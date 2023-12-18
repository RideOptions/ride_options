import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

// ignore: must_be_immutable
class SepratorLine extends StatelessWidget {
  double? verticalMargin;
  double? horizontalMargin;

  SepratorLine({this.verticalMargin = 20, this.horizontalMargin = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: verticalMargin!, horizontal: horizontalMargin!),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: placeholderColor.withOpacity(0.5),
    );
  }
}
