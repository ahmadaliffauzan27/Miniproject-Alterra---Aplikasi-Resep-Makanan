import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supercharged/supercharged.dart';

Color greyColor = "8D92A3".toColor();
Color mainColor = "FFC700".toColor();

TextStyle greyFontStyle = GoogleFonts.poppins().copyWith(color: greyColor);
TextStyle blackFontStyle1 = GoogleFonts.poppins()
    .copyWith(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500);
TextStyle blackFontStyle2 = GoogleFonts.poppins()
    .copyWith(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
TextStyle blackFontStyle3 = GoogleFonts.poppins().copyWith(color: Colors.black);
TextStyle titleFont =
    GoogleFonts.poppins().copyWith(color: Colors.black, fontSize: 16);
TextStyle subtitleFont =
    GoogleFonts.poppins().copyWith(color: Colors.black, fontSize: 14);

const double defaultMargin = 24;
