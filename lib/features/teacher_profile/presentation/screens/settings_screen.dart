import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/core/themes/theme_cubit.dart';
import 'package:treemov/core/widgets/auth/logout_dialog.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/profile_header_card.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_appearance_section.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_notifications_section.dart';
// Импорты новых секций
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_profile_section.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_security_section.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_support_section.dart';
import 'package:treemov/features/teacher_profile/presentation/widgets/settings_system_section.dart';
import 'package:treemov/shared/data/models/org_member_response_model.dart';

class SettingsScreen extends StatefulWidget {
  final OrgMemberResponseModel? orgMember;

  const SettingsScreen({super.key, required this.orgMember});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
  bool _pushNotificationsEnabled = true;
  bool _showPhotosInLists = true;
  bool _soundEnabled = true;
  bool _autoSaveEnabled = true;

  void _navigate(String destination) {
    debugPrint('Navigate to: $destination');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: AppTextStyles.ttNorms20W900.themed(context),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // 1. Профиль (Header)
          ProfileHeaderCard(orgMember: widget.orgMember),
          const SizedBox(height: 16),

          SettingsProfileSection(
            onEditProfileTap: () => _navigate('Edit Profile'),
            onChangePhotoTap: () => _navigate('Change Photo'),
          ),

          SettingsNotificationsSection(
            notificationsEnabled: _notificationsEnabled,
            emailNotificationsEnabled: _emailNotificationsEnabled,
            pushNotificationsEnabled: _pushNotificationsEnabled,
            onNotificationsChanged: (v) =>
                setState(() => _notificationsEnabled = v),
            onEmailChanged: (v) =>
                setState(() => _emailNotificationsEnabled = v),
            onPushChanged: (v) => setState(() => _pushNotificationsEnabled = v),
          ),

          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final themeCubit = context.read<ThemeCubit>();

              return SettingsAppearanceSection(
                darkModeEnabled: themeMode == ThemeMode.dark,
                showPhotosInLists: _showPhotosInLists,
                onDarkModeChanged: (v) {
                  themeCubit.setTheme(v);
                },
                onShowPhotosChanged: (v) =>
                    setState(() => _showPhotosInLists = v),
              );
            },
          ),

          SettingsSystemSection(
            soundEnabled: _soundEnabled,
            autoSaveEnabled: _autoSaveEnabled,
            onSoundChanged: (v) => setState(() => _soundEnabled = v),
            onAutoSaveChanged: (v) => setState(() => _autoSaveEnabled = v),
          ),

          SettingsSecuritySection(
            onChangePasswordTap: () => _navigate('Change Password'),
            onTwoFactorTap: () => _navigate('2FA Settings'),
          ),

          SettingsSupportSection(
            onHelpTap: () => _navigate('Help'),
            onFeedbackTap: () => _navigate('Feedback'),
            onAboutTap: () => _navigate('About'),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () => LogoutDialog.show(context: context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: BorderSide(color: theme.colorScheme.error, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: theme.colorScheme.error,
              ),
              child: Text(
                'Выйти из аккаунта',
                style: AppTextStyles.ttNorms16W600.withColor(
                  theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
