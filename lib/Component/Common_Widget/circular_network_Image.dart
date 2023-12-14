import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

Widget CircleNetworkImageFrame(String url,double height,double width,String? imagePath){
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,


        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primaryColor,)),
    errorWidget: (context, url, error) =>Image.asset((imagePath!=null)?imagePath:"assets/images/user.png",width: width/2,),
  );
}
Widget RectangularNetworkImageFrame(String url,double height,double width,String? imagePath){
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,


        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primaryColor,)),
    errorWidget: (context, url, error) =>Image.asset((imagePath!=null)?imagePath:"assets/images/user.png",width: 25,),
  );
}