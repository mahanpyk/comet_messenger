import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle _base = TextStyle(
    fontFamily: GoogleFonts.roboto().fontFamily,
    color: AppColors.tertiaryColor,
  );
  static final textTheme = TextTheme(
    displayLarge: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 36.0,
    ),
    displayMedium: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 32.0,
    ),
    displaySmall: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 28.0,
    ),
    headlineMedium: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 24.0,
    ),
    headlineSmall: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 20.0,
    ),
    titleLarge: _base.copyWith(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontSize: 18.0,
    ),
    titleMedium: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16.0,
    ),
    titleSmall: _base.copyWith(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontSize: 14.0,
    ),
    bodyLarge: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16.0,
    ),
    bodyMedium: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 14.0,
    ),
    bodySmall: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 12.0,
    ),
    labelLarge: _base.copyWith(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontSize: 14.0,
    ),
    labelSmall: _base.copyWith(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 10.0,
    ),
  );
}
