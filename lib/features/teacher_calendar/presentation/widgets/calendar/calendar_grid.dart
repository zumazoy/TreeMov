import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../../utils/calendar_utils.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime currentDate;
  final DateTime? selectedDate;
  final Set<String> eventDates;
  final Function(DateTime) onDateSelected;

  const CalendarGrid({
    super.key,
    required this.currentDate,
    required this.selectedDate,
    required this.eventDates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<DateTime?> calendarDays = CalendarUtils.generateMonthDays(
      currentDate,
    );

    final primaryColor = AppColors.teacherPrimary;
    final textColor = isDark ? AppColors.darkText : AppColors.notesDarkText;
    final selectedBgColor = primaryColor.withAlpha(51);

    return SizedBox(
      width: 327,
      height: CalendarUtils.calculateCalendarHeight(currentDate),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: calendarDays.length,
        itemBuilder: (context, index) {
          final day = calendarDays[index];
          if (day == null) return const SizedBox();

          final isSelected = CalendarUtils.isSameDay(day, selectedDate);
          final isToday = CalendarUtils.isToday(day);
          final hasEvents = eventDates.contains(
            CalendarUtils.formatDateKey(day),
          );

          return GestureDetector(
            onTap: () => onDateSelected(day),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: isToday
                    ? Border.all(color: primaryColor, width: 1)
                    : null,
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? selectedBgColor : Colors.transparent,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      day.day.toString(),
                      style: AppTextStyles.ttNorms20W700.withColor(textColor),
                    ),
                  ),
                  if (hasEvents)
                    Positioned(
                      bottom: 1,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
