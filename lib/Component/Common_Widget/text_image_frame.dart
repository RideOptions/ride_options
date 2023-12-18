import 'package:flutter/material.dart';

import '../theme/text_style_theme.dart';

// ignore: must_be_immutable
class TextImageFrame extends StatelessWidget {
  String? text;
  String? imageUrl;
  Function()? onTap;
  bool? imageVisible;
  TextImageFrame(
      {this.text, this.imageUrl, this.onTap, this.imageVisible = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(
                0.0,
                2.0,
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
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: (imageVisible == true)
            ? Chip(
                backgroundColor: Colors.white,
                avatar: Image.asset(
                  imageUrl!,
                  width: 20,
                  height: 20,
                ),
                label: Text(
                  text ?? "",
                  style: blackTextRegularIn16px(),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  text ?? "",
                  style: blackTextRegularIn16px(),
                ),
              ),
      ),
    );
  }
}
