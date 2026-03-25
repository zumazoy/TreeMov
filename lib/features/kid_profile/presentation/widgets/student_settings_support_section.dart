import 'package:flutter/material.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_card.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_nav_row.dart';

class StudentSettingsSupportSection extends StatelessWidget {
  final VoidCallback onHelpTap;
  final VoidCallback onFeedbackTap;
  final VoidCallback onAboutTap;

  const StudentSettingsSupportSection({
    super.key,
    required this.onHelpTap,
    required this.onFeedbackTap,
    required this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentSettingsCard(
          children: [
            StudentSettingsNavRow(
              title: 'Справка',
              subtitle: 'Руководство пользователя',
              onTap: onHelpTap,
            ),
            StudentSettingsNavRow(
              title: 'Обратная связь',
              subtitle: 'Отправить отзыв или предложение',
              onTap: onFeedbackTap,
            ),
            StudentSettingsNavRow(
              title: 'О приложении',
              subtitle: 'Версия 1.0.0',
              onTap: onAboutTap,
            ),
          ],
        ),
      ],
    );
  }
}
