import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../../utils/calendar_utils.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final VoidCallback onNextMonth;
  final VoidCallback onPrevMonth;

  const CalendarHeader({
    super.key,
    required this.currentDate,
    required this.onNextMonth,
    required this.onPrevMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.teacherPrimary,
        borderRadius: BorderRadius.circular(12.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.white,
              size: 24,
            ),
            onPressed: onPrevMonth,
          ),
          Center(
            child: Text(
              CalendarUtils.getMonthYearText(currentDate),
              style: AppTextStyles.ttNorms20W700.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.chevron_right,
              color: AppColors.white,
              size: 24,
            ),
            onPressed: onNextMonth,
          ),
        ],
      ),
    );
  }
}
