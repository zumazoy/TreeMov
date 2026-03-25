import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/core/widgets/layout/nav_bar.dart';
import 'package:treemov/features/teacher_calendar/presentation/screens/update_lesson_screen.dart';
import 'package:treemov/shared/domain/entities/lesson_entity.dart';
import 'package:treemov/temp/teacher_screen.dart';

import '../widgets/change_event_modal.dart';
import '../widgets/delete_event_modal.dart';

class LessonDetailsScreen extends StatelessWidget {
  final LessonEntity event;

  const LessonDetailsScreen({super.key, required this.event});

  // void _navigateToEditScreen(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => EditEventScreen(
  //         eventId: eventId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
  //         initialGroup: groupName,
  //         initialLessonType: subject,
  //         initialLocation: location,
  //         initialStartDateTime: _parseTime(startTime),
  //         initialEndDateTime: _parseTime(endTime),
  //         initialRepeat: repeat,
  //         initialReminder: 'Добавить напоминание',
  //         initialDescription: description,
  //       ),
  //     ),
  //   );
  // }

  void _showChangeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: ChangeEventModal(
          onOptionSelected: (selectedOption) {
            // Здесь будет логика для BLoC
            // Выбранный вариант: selectedOption

            // Переходим на экран редактирования после выбора
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateLessonScreen(event: event),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Padding(padding: const EdgeInsets.all(20), child: DeleteEventModal()),
    );
  }

  void _onTabTapped(int index, BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherScreen(initialIndex: index),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.grayFieldText;
    final borderColor = isDark ? AppColors.darkSurface : AppColors.eventTap;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text('Событие', style: AppTextStyles.arial20W900.white),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Основная карточка с информацией
                    Container(
                      width: 367,
                      constraints: const BoxConstraints(minHeight: 320),
                      decoration: BoxDecoration(
                        color: cardColor,
                        border: Border.all(color: borderColor, width: 1),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              event.group != null
                                  ? 'Группа "${event.formatTitle(event.group?.title)}"'
                                  : '(Не указан)',
                              style: AppTextStyles.arial16W900.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : Colors.black,
                              ),
                            ),
                          ),

                          _buildInfoRow(
                            iconPath: 'assets/images/activity_icon.png',
                            text: event.subject != null
                                ? event.formatTitle(event.subject?.title)
                                : '(Не указан)',
                            textColor: textColor,
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            iconPath: 'assets/images/place_icon.png',
                            text: event.classroom != null
                                ? event.formatTitle(event.classroom?.title)
                                : '(Не указана)',
                            textColor: textColor,
                          ),
                          const SizedBox(height: 16),

                          _buildTimeSection(
                            textColor: textColor,
                            borderColor: borderColor,
                            dividerColor: theme.dividerColor,
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            iconPath: 'assets/images/bell_icon.png',
                            text: 'Добавить напоминание',
                            textColor: textColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Карточка с описанием
                    Container(
                      width: 367,
                      constraints: const BoxConstraints(minHeight: 120),
                      decoration: BoxDecoration(
                        color: cardColor,
                        border: Border.all(color: borderColor, width: 1),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            iconPath: 'assets/images/desc_icon.png',
                            text: 'Описание',
                            textColor: textColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            event.formatTitle(
                              event.comment,
                              message: 'Описание занятия отсутствует',
                            ),
                            style: AppTextStyles.arial14W400.copyWith(
                              color: textColor,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Нижняя панель с кнопками действий
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    text: 'Изменить',
                    icon: Icons.edit,
                    onPressed: () => _showChangeModal(context),
                    theme: theme,
                  ),

                  const SizedBox(width: 16),

                  _buildActionButton(
                    text: 'Удалить',
                    icon: Icons.delete,
                    onPressed: () => _showDeleteModal(context),
                    theme: theme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) => _onTabTapped(index, context),
      ),
    );
  }

  Widget _buildInfoRow({
    required String iconPath,
    required String text,
    required Color textColor,
  }) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Image.asset(iconPath, width: 20, height: 20, color: textColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.arial14W400.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection({
    required Color textColor,
    required Color borderColor,
    required Color dividerColor,
  }) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.5),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/clock_icon.png',
                    width: 20,
                    height: 20,
                    color: textColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Начало:',
                    style: AppTextStyles.arial14W400.copyWith(color: textColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    event.formatTitle(
                      event.startTime != null
                          ? event.startTime!.substring(0, 5)
                          : event.startTime,
                      message: 'Время начала не задано',
                    ),
                    style: AppTextStyles.arial14W400.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: dividerColor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(width: 32),
                  Text(
                    'Конец:',
                    style: AppTextStyles.arial14W400.copyWith(color: textColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    event.formatTitle(
                      event.endTime != null
                          ? event.endTime!.substring(0, 5)
                          : event.endTime,
                      message: 'Время конца не задано',
                    ),
                    style: AppTextStyles.arial14W400.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkCard : AppColors.white;
    final foregroundColor = isDark ? AppColors.darkText : Colors.black;
    final borderColor = isDark ? AppColors.darkSurface : AppColors.eventTap;

    return SizedBox(
      width: 90,
      height: 61,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.5),
            side: BorderSide(color: borderColor, width: 1),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: foregroundColor),
            const SizedBox(height: 5),
            Text(
              text,
              style: AppTextStyles.arial12W400.copyWith(color: foregroundColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
