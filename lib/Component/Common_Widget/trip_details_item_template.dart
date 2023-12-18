import 'package:flutter/material.dart';

import '../theme/text_style_theme.dart';

// ignore: must_be_immutable
class TripDetailItemTemplate extends StatelessWidget {
  String title;
  String description;
  String? imageUrl;

  TripDetailItemTemplate(
      {required this.title, required this.description, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Icon(
                Icons.key_outlined,
                size: 30,
              )),
          Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: blackTextBoldIn16px(),
                  ),
                  Text(
                    description,
                    style: greyTextRegularIn16px(),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
