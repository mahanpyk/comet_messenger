import 'package:comet_messenger/app/theme/app_colors.dart';
import 'package:comet_messenger/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      }),
      fontFamily: GoogleFonts.roboto().fontFamily,
      appBarTheme: const AppBarTheme(elevation: 0.0),
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      textTheme: AppTextStyles.textTheme,
    );
  }
}

















