import 'package:flutter/material.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_card.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_toggle_row.dart';

class SettingsNotificationsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onPushChanged;

  const SettingsNotificationsSection({
    super.key,
    required this.notificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.pushNotificationsEnabled,
    required this.onNotificationsChanged,
    required this.onEmailChanged,
    required this.onPushChanged,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Column(
      children: [
        SettingsCard(
          children: [
            SettingsToggleRow(
              title: 'Email уведомления',
              subtitle: 'Получать уведомления на почту',
              value: emailNotificationsEnabled,
              onChanged: onEmailChanged,
            ),
          ],
        ),
      ],
    );
  }
}
