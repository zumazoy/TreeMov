import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Color? fillColor;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultFillColor =
        fillColor ?? (isDark ? AppColors.darkCard : AppColors.white);

    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: defaultFillColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.ttNorms16W400.copyWith(
          color: isDark ? AppColors.darkText : AppColors.notesDarkText,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          hintText: hintText,
          hintStyle: AppTextStyles.ttNorms16W700.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            height: 1.0,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
