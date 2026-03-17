import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';

class CustomActionForm extends StatefulWidget {
  final Function(String, String, int) onSave;
  final Function() onCancel;

  const CustomActionForm({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<CustomActionForm> createState() => _CustomActionFormState();
}

class _CustomActionFormState extends State<CustomActionForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final FocusNode _pointsFocusNode = FocusNode();

  void _onSave() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final points = int.tryParse(_pointsController.text) ?? 0;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Введите заголовок действия'),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSurface
              : null,
        ),
      );
      return;
    }

    widget.onSave(title, description, points);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark
              ? AppColors.teacherPrimary.withAlpha(128)
              : AppColors.teacherPrimary,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Создать свое действие',
              style: AppTextStyles.arial14W700.themed(context),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Заголовок действия',
                labelStyle: AppTextStyles.arial14W400.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.grayFieldText,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkSurface : AppColors.eventTap,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkSurface : AppColors.eventTap,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.teacherPrimary),
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              style: AppTextStyles.arial14W400.themed(context),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Описание (необязательно)',
                labelStyle: AppTextStyles.arial14W400.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.grayFieldText,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkSurface : AppColors.eventTap,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkSurface : AppColors.eventTap,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.teacherPrimary),
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              style: AppTextStyles.arial14W400.themed(context),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _pointsController,
              focusNode: _pointsFocusNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Количество баллов',
                labelStyle: AppTextStyles.arial14W400.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.grayFieldText,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkSurface : AppColors.eventTap,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkSurface : AppColors.eventTap,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.teacherPrimary),
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              style: AppTextStyles.arial14W400.themed(context),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Введите число баллов',
                style: AppTextStyles.arial11W400.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.grayFieldText,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.darkText
                          : AppColors.notesDarkText,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.eventTap,
                      ),
                      backgroundColor: isDark
                          ? AppColors.darkSurface
                          : AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Отмена',
                      style: AppTextStyles.arial14W400.themed(context),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teacherPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Сохранить',
                      style: AppTextStyles.arial14W400.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
