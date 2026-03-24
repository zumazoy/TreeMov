import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';

class CalendarWeekDays extends StatelessWidget {
  const CalendarWeekDays({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const List<String> weekDays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    final textColor = (isDark ? AppColors.darkText : AppColors.notesDarkText)
        .withAlpha(128);

    return SizedBox(
      width: 327,
      height: 40,
      child: Row(
        children: weekDays.map((day) {
          return Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                day,
                style: AppTextStyles.ttNorms16W700.withColor(textColor),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
