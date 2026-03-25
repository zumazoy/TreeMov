import 'package:flutter/material.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_card.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_toggle_row.dart';

class SettingsAppearanceSection extends StatelessWidget {
  final bool darkModeEnabled;
  final bool showPhotosInLists;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onShowPhotosChanged;

  const SettingsAppearanceSection({
    super.key,
    required this.darkModeEnabled,
    required this.showPhotosInLists,
    required this.onDarkModeChanged,
    required this.onShowPhotosChanged,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Column(
      children: [
        SettingsCard(
          children: [
            SettingsToggleRow(
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
