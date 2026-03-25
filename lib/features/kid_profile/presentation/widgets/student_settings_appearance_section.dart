import 'package:flutter/material.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_card.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_toggle_row.dart';

class StudentSettingsAppearanceSection extends StatelessWidget {
  final bool darkModeEnabled;
  final bool showProgress;
  final bool showPhotosInLists;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onShowProgressChanged;
  final ValueChanged<bool> onShowPhotosChanged;

  const StudentSettingsAppearanceSection({
    super.key,
    required this.darkModeEnabled,
    required this.showProgress,
    required this.showPhotosInLists,
    required this.onDarkModeChanged,
    required this.onShowProgressChanged,
    required this.onShowPhotosChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentSettingsCard(
          children: [
            StudentSettingsToggleRow(
              title: 'Тёмная тема',
              subtitle: 'Использовать тёмное оформление',
              value: darkModeEnabled,
              onChanged: onDarkModeChanged,
            ),
          ],
        ),
      ],
    );
  }
}
