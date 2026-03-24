import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';

class AppBarTitle extends StatelessWidget {
  final String text;
  final String? iconPath;

  const AppBarTitle({super.key, required this.text, this.iconPath});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = AppTextStyles.ttNorms20W700.withColor(
      isDark ? AppColors.darkText : AppColors.notesDarkText,
    );

    if (iconPath == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(text, style: textStyle),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath!,
            width: 24,
            height: 24,
            color: isDark ? AppColors.darkText : AppColors.notesDarkText,
          ),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}
