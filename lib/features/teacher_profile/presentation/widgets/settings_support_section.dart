import 'package:flutter/material.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_card.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_nav_row.dart';

class SettingsSupportSection extends StatelessWidget {
  final VoidCallback onHelpTap;
  final VoidCallback onFeedbackTap;
  final VoidCallback onAboutTap;

  const SettingsSupportSection({
    super.key,
    required this.onHelpTap,
    required this.onFeedbackTap,
    required this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Column(
      children: [
        SettingsCard(
          children: [
            SettingsNavRow(
              title: 'Справка',
              subtitle: 'Руководство пользователя',
              onTap: onHelpTap,
            ),
            SettingsNavRow(
              title: 'Обратная связь',
              subtitle: 'Отправить отзыв или предложение',
              onTap: onFeedbackTap,
            ),
            SettingsNavRow(
              title: 'О системе',
              subtitle: 'Версия 1.0.0',
              onTap: onAboutTap,
            ),
          ],
        ),
      ],
    );
  }
}
