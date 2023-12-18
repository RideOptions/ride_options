import 'package:flutter/material.dart';

import 'circular_network_Image.dart';

// ignore: must_be_immutable
class CircularImageFrame extends StatelessWidget {
  String imageUrl;
  double outerCircleRadius;
  double circleRadius;

  CircularImageFrame(
      {required this.imageUrl,
      required this.outerCircleRadius,
      required this.circleRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
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
        ],
        borderRadius: BorderRadius.all(Radius.circular(outerCircleRadius)),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: outerCircleRadius,
        child: CircleAvatar(
          radius: circleRadius,
          backgroundColor: Colors.white,
          child: CircleNetworkImageFrame(
              imageUrl, circleRadius * 2, circleRadius * 2, null),
        ),
      ),
    );
  }
}
