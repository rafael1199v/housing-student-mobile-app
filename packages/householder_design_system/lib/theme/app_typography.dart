import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';


class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(TextTheme base) {
    final jakarta = GoogleFonts.plusJakartaSansTextTheme(base);

    return jakarta.copyWith(
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.1,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.textSecondary,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.label,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}
