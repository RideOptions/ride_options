import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var button =
     ElevatedButton.styleFrom(
        minimumSize: const Size(264, 40),
        backgroundColor: const Color(0xffD8543B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ));

var buttonTextStyle = GoogleFonts.getFont("Roboto Condensed", fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,);
var blackButton = GoogleFonts.getFont(
  "Roboto Condensed",
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.black,
);
var border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25.0),
  borderSide: BorderSide(
    color: Colors.orange,
    width: 1.5,
  ),
);
