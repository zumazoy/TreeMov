import 'package:flutter/material.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_card.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_toggle_row.dart';

class StudentSettingsNotificationsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final bool parentNotificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onParentNotificationsChanged;

  const StudentSettingsNotificationsSection({
    super.key,
    required this.notificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.pushNotificationsEnabled,
    required this.parentNotificationsEnabled,
    required this.onNotificationsChanged,
    required this.onEmailChanged,
    required this.onPushChanged,
    required this.onParentNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentSettingsCard(
          children: [
            StudentSettingsToggleRow(
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
