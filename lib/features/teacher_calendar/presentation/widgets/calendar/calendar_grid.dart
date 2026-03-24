import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final List<DateTime?> calendarDays = CalendarUtils.generateMonthDays(
      currentDate,
    );

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
                    ? Border.all(color: theme.colorScheme.primary, width: 1)
                    : null,
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? theme.colorScheme.primary.withAlpha(51)
                    : Colors.transparent,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Arial',
                        height: 1.0,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
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
                            color: theme.colorScheme.primary,
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
