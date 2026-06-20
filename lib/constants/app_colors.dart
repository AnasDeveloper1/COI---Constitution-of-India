
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff0F172A);
  static const Color secondary = Color(0xffF59E0B);

  static const Color white = Colors.white;

  static const Color background = Color(0xffF8FAFC);

  static const LinearGradient primaryGradient =
      LinearGradient(
    colors: [
      Color(0xff0F172A),
      Color(0xff1E3A8A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}