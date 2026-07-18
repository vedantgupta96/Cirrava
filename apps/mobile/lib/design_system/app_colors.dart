import 'package:flutter/material.dart';

abstract final class AppColors {
  static const night = Color(0xFF05070F);
  static const surface = Color(0xFF0A0F1E);
  static const surfaceRaised = Color(0xFF0A1022);
  static const surfaceSoft = Color(0xFF0C1226);
  static const stroke = Color(0x242F477D);

  static const ink = Color(0xFFEAF0FF);
  static const inkSoft = Color(0xFFC6D2F2);
  static const muted = Color(0xFF8296C9);
  static const mutedDeep = Color(0xFF5D6A94);

  static const amber = Color(0xFFFFB454);
  static const amberLight = Color(0xFFFFCD8A);
  static const cyan = Color(0xFF6FD8FF);
  static const violet = Color(0xFFA98BFF);
  static const cancelled = Color(0xFFFF6B5E);

  static const paper = Color(0xFFF2ECE0);
  static const paperInk = Color(0xFF211D16);
  static const paperMuted = Color(0xFF8A7D63);

  // Semantic aliases retained for domain-facing widgets.
  static const signal = amber;
  static const signalLight = amberLight;
  static const canvas = night;
  static const accent = cyan;
  static const onTime = cyan;
  static const delayed = amber;
  static const darkCanvas = night;
  static const darkSurface = surface;
  static const darkInk = ink;
}
