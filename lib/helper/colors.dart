import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var color = const Color(0xffD8543B);
var appbar = GoogleFonts.getFont(
  "Roboto Condensed",
  color: Colors.black,
  fontSize: 25,
  fontWeight: FontWeight.w600,
);
var image = Image(image: AssetImage("assets/svgImages/21.jpg",),height: 195, width: 200,);
void logo(BuildContext context, Widget logo){
Image(image: AssetImage("assets/svgImages/21.jpg",),height: MediaQuery.of(context).size.height*0.02, width: MediaQuery.of(context).size.width*0.10,);
}

var back = Color(0xffF5F5F5);
// DecoratedBox(
// decoration: BoxDecoration(
// image: DecorationImage(
// repeat: ImageRepeat.repeat,
// image: Svg(
// 'assets/test.svg',
// size: Size(10, 10),
// ),
