import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
var appbar =  GoogleFonts.getFont("Roboto Condensed", color: Colors.black,
  fontSize: 18, fontWeight: FontWeight.w600,
);
var button =  GoogleFonts.getFont("Roboto Condensed", fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,);
var buttons =  GoogleFonts.getFont("Roboto Condensed", fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black,);
var gen = GoogleFonts.getFont("Roboto Condensed", fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xff949494));
var genral = GoogleFonts.getFont("Roboto", color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600);
var textfield = GoogleFonts.getFont("Roboto", color: Color(0xff767676), fontSize: 14, fontWeight: FontWeight.w400);
var colors = Color(0xffD8543B);
var genr = GoogleFonts.getFont("Roboto Condensed", fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black,);

void openScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

void openScreenAndCloseOthers(BuildContext context, Widget screen) {
  Navigator.popUntil(context, (route) => false);
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

