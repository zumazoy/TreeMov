import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _ttNorms = 'TT Norms';
  static const String _arial = 'Arial';
  static const double _lineHeight = 1.0;

  // ========== БАЗОВЫЕ МЕТОДЫ ==========
  static TextStyle _base(double size, FontWeight weight, String fontFamily) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontFamily: fontFamily,
      height: _lineHeight,
    );
  }

  // ========== БАЗОВЫЕ СТИЛИ ==========

  // TT Norms
  static TextStyle ttNorms(double size, FontWeight weight) =>
      _base(size, weight, _ttNorms);

  // Arial
  static TextStyle arial(double size, FontWeight weight) =>
      _base(size, weight, _arial);

  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  // TT Norms
  static TextStyle get ttNorms24W900 => ttNorms(24, FontWeight.w900);
  static TextStyle get ttNorms24W700 => ttNorms(24, FontWeight.w700);
  static TextStyle get ttNorms22W900 => ttNorms(22, FontWeight.w900);
  static TextStyle get ttNorms20W900 => ttNorms(20, FontWeight.w900);
  static TextStyle get ttNorms20W700 => ttNorms(20, FontWeight.w700);
  static TextStyle get ttNorms20W500 => ttNorms(20, FontWeight.w500);
  static TextStyle get ttNorms18W700 => ttNorms(18, FontWeight.w700);

  static TextStyle get ttNorms16W700 => ttNorms(16, FontWeight.w700);
  static TextStyle get ttNorms16W600 => ttNorms(16, FontWeight.w600);
  static TextStyle get ttNorms16W500 => ttNorms(16, FontWeight.w500);
  static TextStyle get ttNorms16W400 => ttNorms(16, FontWeight.w400);
  static TextStyle get ttNorms16W900 => ttNorms(16, FontWeight.w900);

  static TextStyle get ttNorms14W900 => ttNorms(14, FontWeight.w900);
  static TextStyle get ttNorms14W700 => ttNorms(14, FontWeight.w700);
  static TextStyle get ttNorms14W600 => ttNorms(14, FontWeight.w600);
  static TextStyle get ttNorms14W500 => ttNorms(14, FontWeight.w500);
  static TextStyle get ttNorms14W400 => ttNorms(14, FontWeight.w400);

  static TextStyle get ttNorms13W400 => ttNorms(13, FontWeight.w400);

  static TextStyle get ttNorms12W900 => ttNorms(12, FontWeight.w900);
  static TextStyle get ttNorms12W700 => ttNorms(12, FontWeight.w700);
  static TextStyle get ttNorms12W600 => ttNorms(12, FontWeight.w600);
  static TextStyle get ttNorms12W500 => ttNorms(12, FontWeight.w500);
  static TextStyle get ttNorms12W400 => ttNorms(12, FontWeight.w400);

  static TextStyle get ttNorms11W600 => ttNorms(11, FontWeight.w600);
  static TextStyle get ttNorms11W400 => ttNorms(11, FontWeight.w400);
  static TextStyle get ttNorms11W300 => ttNorms(11, FontWeight.w300);

  static TextStyle get ttNorms10W700 => ttNorms(10, FontWeight.w700);
  static TextStyle get ttNorms10W500 => ttNorms(10, FontWeight.w500);
  static TextStyle get ttNorms10W400 => ttNorms(10, FontWeight.w400);
  static TextStyle get ttNorms10W300 => ttNorms(10, FontWeight.w300);

  // Arial
  static TextStyle get arial20W700 => arial(20, FontWeight.w700);
  static TextStyle get arial18W700 => arial(18, FontWeight.w700);
  static TextStyle get arial16W700 => arial(16, FontWeight.w700);
  static TextStyle get arial16W400 => arial(16, FontWeight.w400);
  static TextStyle get arial14W700 => arial(14, FontWeight.w700);
  static TextStyle get arial14W500 => arial(14, FontWeight.w500);
  static TextStyle get arial14W400 => arial(14, FontWeight.w400);
  static TextStyle get arial12W400 => arial(12, FontWeight.w400);
  static TextStyle get arial12W700 => arial(12, FontWeight.w700);
  static TextStyle get arial11W400 => arial(11, FontWeight.w400);
  static TextStyle get arial18W900 => arial(18, FontWeight.w900);
  static TextStyle get arial20W900 => arial(20, FontWeight.w900);
  static TextStyle get arial16W900 => arial(16, FontWeight.w900);
  static TextStyle get arial16W500 => arial(16, FontWeight.w500);
}

// ========== EXTENSIONS ==========
extension TextStyleExtensions on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);

  TextStyle get dark => copyWith(color: AppColors.notesDarkText);
  TextStyle get white => copyWith(color: AppColors.white);
  TextStyle get black => copyWith(color: AppColors.black);
  TextStyle get grey => copyWith(color: AppColors.directoryTextSecondary);
  TextStyle get lightGrey => copyWith(color: AppColors.lightGrey);
  TextStyle get primary => copyWith(color: AppColors.teacherPrimary);
  TextStyle get error => copyWith(color: AppColors.activityRed);
  TextStyle get success => copyWith(color: AppColors.statsTotalText);

  TextStyle themed(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return copyWith(
      color: isDark ? AppColors.darkText : AppColors.notesDarkText,
    );
  }

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
}

// ========== ШПАРГАЛКА ПО FONTWEIGHT ==========
// w900 (Black)   - Главные заголовки экранов
// w700 (Bold)    - Подзаголовки, имена, важные числа
// w600 (SemiBold)- Кнопки, пункты меню
// w500 (Medium)  - Обычный текст, описания
// w400 (Regular) - Второстепенный текст, поля ввода
// w300 (Light)   - Даты, мелкие подписи
// =============================================
