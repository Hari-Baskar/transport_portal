import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textWidget({
  required String text,
  required FontWeight fontWeight,
  required double fontsize,
  required Color fontColor,
  Spacing,
})  => Text(text,style: GoogleFonts.poppins(
  fontSize: fontsize,
  color: fontColor,
  fontWeight: fontWeight,
  letterSpacing: Spacing,
),

);