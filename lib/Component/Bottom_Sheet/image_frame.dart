import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ImageFrame extends StatelessWidget {
  Function()? onTap;
  String? imageUrl;
  double? width;
  double? height;
  bool? hasShadow;
  Color? bgColor;
  double? imageWidth;
  double? imageHeight;
  double? framePadding;
  ImageFrame({this.onTap,this.imageUrl,this.width,this.height,this.hasShadow=true,this.bgColor,this.imageHeight=20,this.imageWidth=20,this.framePadding=10});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width??35,
        height: height??35,
        padding: EdgeInsets.all(framePadding!),
        decoration: BoxDecoration(
          color: bgColor?? Colors.white,
          boxShadow:(hasShadow==true)? [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(
                0.0,
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
          ]:[],
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Image.asset(
          imageUrl!,
          width: imageWidth,
          height:imageHeight,
        ),
      ),
    );
  }
}
