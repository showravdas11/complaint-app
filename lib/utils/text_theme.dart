import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static final TextStyle englishTextStyle = GoogleFonts.ubuntu();
  static final TextStyle bengaliTextStyle = GoogleFonts.balooDa2();

  static TextTheme textTheme = TextTheme(
    bodyLarge: englishTextStyle,
    bodyMedium: bengaliTextStyle,
    titleLarge: englishTextStyle,
  );
}
