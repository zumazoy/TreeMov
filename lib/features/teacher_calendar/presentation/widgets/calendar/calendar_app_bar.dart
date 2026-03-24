import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';

class CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalendarAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
      elevation: 0,
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/calendar_simple_icon.png',
            width: 24,
            height: 24,
            color: isDark ? AppColors.darkText : AppColors.notesDarkText,
          ),
          const SizedBox(width: 8),
          Text(
            'Календарь',
            style: AppTextStyles.ttNorms20W700.withColor(
              isDark ? AppColors.darkText : AppColors.notesDarkText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
