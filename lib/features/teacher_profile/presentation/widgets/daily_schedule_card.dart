import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/shared/data/models/lesson_response_model.dart';
import 'package:treemov/temp/teacher_screen.dart';

class DailyScheduleCard extends StatelessWidget {
  final List<LessonResponseModel> todayLessons;

  const DailyScheduleCard({super.key, required this.todayLessons});

  int get totalLessons => todayLessons.length;

  LessonResponseModel? get nextLesson {
    final now = DateTime.now();
    final upcomingLessons = todayLessons.where((lesson) {
      if (lesson.startTime == null) return false;

      final lessonTimeParts = lesson.startTime!.split(':');
      if (lessonTimeParts.length < 2) return false;

      final lessonHour = int.tryParse(lessonTimeParts[0]) ?? 0;
      final lessonMinute = int.tryParse(lessonTimeParts[1]) ?? 0;

      final lessonDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        lessonHour,
        lessonMinute,
      );

      return lessonDateTime.isAfter(now) ||
          (lessonDateTime.isBefore(
                now.add(
                  Duration(
                    minutes: lesson.duration != null
                        ? int.tryParse(lesson.duration!) ?? 45
                        : 45,
                  ),
                ),
              ) &&
              lessonDateTime.isAfter(now.subtract(const Duration(minutes: 5))));
    }).toList();

    if (upcomingLessons.isEmpty) return null;

    upcomingLessons.sort((a, b) {
      if (a.startTime == null || b.startTime == null) return 0;
      return a.startTime!.compareTo(b.startTime!);
    });

    return upcomingLessons.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLessonsToday = todayLessons.isNotEmpty;
    final nextLesson = this.nextLesson;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.cardColor,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/grad_calendar.png',
                      width: 20,
                      height: 20,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Мой день',
                      style: AppTextStyles.arial20W700.themed(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (hasLessonsToday)
                  _buildScheduleItem(
                    context,
                    'assets/images/book_icon.png',
                    '$totalLessons ${_getLessonWord(totalLessons)} сегодня',
                    theme.colorScheme.primary,
                    isNumberColored: true,
                  ),

                if (!hasLessonsToday)
                  _buildScheduleItem(
                    context,
                    'assets/images/book_icon.png',
                    'Сегодня нет занятий',
                    theme.colorScheme.primary,
                  ),

                if (hasLessonsToday) const SizedBox(height: 12),

                if (nextLesson != null && hasLessonsToday)
                  _buildScheduleItem(
                    context,
                    'assets/images/clock_icon.png',
                    'Следующий: ${nextLesson.group?.title ?? "Группа не указана"} ${_formatTimeRange(nextLesson)}',
                    theme.colorScheme.secondary,
                    isTimeColored: true,
                  ),

                if (nextLesson == null && hasLessonsToday)
                  _buildScheduleItem(
                    context,
                    'assets/images/clock_icon.png',
                    'Занятия на сегодня закончились',
                    theme.colorScheme.secondary,
                  ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: theme.dividerColor,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const TeacherScreen(initialIndex: 0),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Нажмите для просмотра расписания',
                    style: AppTextStyles.arial12W700.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/purple_arrow.png',
                    width: 16,
                    height: 16,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLessonWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'занятие';
    if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 10 || count % 100 >= 20)) {
      return 'занятия';
    }
    return 'занятий';
  }

  String _formatTimeRange(LessonResponseModel lesson) {
    if (lesson.startTime == null || lesson.endTime == null) {
      return lesson.formattedTimeRange;
    }

    final start = lesson.formatTime(lesson.startTime!);
    final end = lesson.formatTime(lesson.endTime!);
    return '$start–$end';
  }

  Widget _buildScheduleItem(
    BuildContext context,
    String iconPath,
    String text,
    Color color, {
    bool isNumberColored = false,
    bool isTimeColored = false,
    bool isReminderColored = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 16,
          height: 16,
          color: theme.iconTheme.color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildColoredText(
            context,
            text,
            color,
            isNumberColored: isNumberColored,
            isTimeColored: isTimeColored,
            isReminderColored: isReminderColored,
          ),
        ),
      ],
    );
  }

  Widget _buildColoredText(
    BuildContext context,
    String text,
    Color color, {
    bool isNumberColored = false,
    bool isTimeColored = false,
    bool isReminderColored = false,
  }) {
    Theme.of(context);
    final baseStyle = AppTextStyles.arial14W400.themed(context);

    if (isNumberColored) {
      final numberMatch = RegExp(r'\d+').firstMatch(text);
      if (numberMatch != null) {
        final number = numberMatch.group(0)!;
        final before = text.substring(0, numberMatch.start);
        final after = text.substring(numberMatch.end);

        return RichText(
          text: TextSpan(
            style: baseStyle,
            children: [
              TextSpan(text: before),
              TextSpan(
                text: number,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: after),
            ],
          ),
        );
      }
    } else if (isTimeColored) {
      final timeMatch = RegExp(r'\d{2}:\d{2}–\d{2}:\d{2}').firstMatch(text);
      if (timeMatch != null) {
        final time = timeMatch.group(0)!;
        final before = text.substring(0, timeMatch.start);
        final after = text.substring(timeMatch.end);

        return RichText(
          text: TextSpan(
            style: baseStyle,
            children: [
              TextSpan(text: before),
              TextSpan(
                text: time,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
              TextSpan(text: after),
            ],
          ),
        );
      }
    } else if (isReminderColored) {
      final reminderMatch = RegExp(r'Напоминание: (.+)').firstMatch(text);
      if (reminderMatch != null && reminderMatch.groupCount >= 1) {
        final reminderText = reminderMatch.group(1)!;

        return RichText(
          text: TextSpan(
            style: baseStyle,
            children: [
              const TextSpan(text: 'Напоминание: '),
              TextSpan(
                text: reminderText,
                style: TextStyle(color: color, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }
    }

    return Text(text, style: baseStyle);
  }
}
