import 'package:flutter/material.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_card.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_nav_row.dart';

class StudentSettingsSecuritySection extends StatelessWidget {
  final VoidCallback onChangePasswordTap;
  final VoidCallback onTwoFactorTap; // Новый параметр
  final VoidCallback onParentControlTap;
  final VoidCallback onPrivacyPolicyTap; // Новый параметр

  const StudentSettingsSecuritySection({
    super.key,
    required this.onChangePasswordTap,
    required this.onTwoFactorTap,
    required this.onParentControlTap,
    required this.onPrivacyPolicyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentSettingsCard(
          children: [
            StudentSettingsNavRow(
              title: 'Изменить пароль',
              subtitle: 'Обновить пароль для входа',
              onTap: onChangePasswordTap,
            ),
            StudentSettingsNavRow(
              title: 'Двухфакторная аутентификация',
              subtitle: 'Настроить дополнительную защиту',
              onTap: onTwoFactorTap,
            ),
          ],
        ),
      ],
    );
  }
}
