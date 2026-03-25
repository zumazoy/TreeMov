import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/routes/app_routes.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/core/themes/theme_cubit.dart';
import 'package:treemov/core/widgets/auth/logout_dialog.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_profile_header_card.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_appearance_section.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_notifications_section.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_profile_section.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_security_section.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/student_settings_support_section.dart';
import 'package:treemov/shared/data/models/student_response_model.dart';

class StudentSettingsScreen extends StatefulWidget {
  final StudentResponseModel? studentProfile;

  const StudentSettingsScreen({super.key, required this.studentProfile});

  @override
  State<StudentSettingsScreen> createState() => _StudentSettingsScreenState();
}

class _StudentSettingsScreenState extends State<StudentSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
  bool _pushNotificationsEnabled = true;
  bool _showProgress = true;
  // bool _soundEnabled = true;
  // bool _autoSaveEnabled = true;
  bool _parentNotifications = false;
  bool _showPhotosInLists = true;
  // bool _offlineModeEnabled = false;

  void _navigate(String destination) {
    debugPrint('Navigate to: $destination');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Переход к: $destination')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kidPrimary,
      appBar: AppBar(
        title: Text('Настройки', style: AppTextStyles.ttNorms20W900.white),
        backgroundColor: AppColors.kidPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          StudentProfileHeaderCard(student: widget.studentProfile),
          const SizedBox(height: 16),

          StudentSettingsProfileSection(
            onEditProfileTap: () => _navigate('Edit Profile'),
            onChangePhotoTap: () => _navigate('Change Photo'),
            onMyOrgsTap: () {
              Navigator.pushNamed(context, AppRoutes.myOrgs);
            },
          ),

          StudentSettingsNotificationsSection(
            notificationsEnabled: _notificationsEnabled,
            emailNotificationsEnabled: _emailNotificationsEnabled,
            pushNotificationsEnabled: _pushNotificationsEnabled,
            parentNotificationsEnabled: _parentNotifications,
            onNotificationsChanged: (v) =>
                setState(() => _notificationsEnabled = v),
            onEmailChanged: (v) =>
                setState(() => _emailNotificationsEnabled = v),
            onPushChanged: (v) => setState(() => _pushNotificationsEnabled = v),
            onParentNotificationsChanged: (v) =>
                setState(() => _parentNotifications = v),
          ),

          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final themeCubit = context.read<ThemeCubit>();
              return StudentSettingsAppearanceSection(
                darkModeEnabled: themeMode == ThemeMode.dark,
                showProgress: _showProgress,
                showPhotosInLists: _showPhotosInLists,
                onDarkModeChanged: (v) => themeCubit.setTheme(v),
                onShowProgressChanged: (v) => setState(() => _showProgress = v),
                onShowPhotosChanged: (v) =>
                    setState(() => _showPhotosInLists = v),
              );
            },
          ),

          // StudentSettingsSystemSection(
          //   soundEnabled: _soundEnabled,
          //   autoSaveEnabled: _autoSaveEnabled,
          //   offlineModeEnabled: _offlineModeEnabled,
          //   onSoundChanged: (v) => setState(() => _soundEnabled = v),
          //   onAutoSaveChanged: (v) => setState(() => _autoSaveEnabled = v),
          //   onOfflineModeChanged: (v) =>
          //       setState(() => _offlineModeEnabled = v),
          // ),
          StudentSettingsSecuritySection(
            onChangePasswordTap: () => _navigate('Change Password'),
            onTwoFactorTap: () => _navigate('Two Factor Auth'),
            onParentControlTap: () => _navigate('Parent Control'),
            onPrivacyPolicyTap: () => _navigate('Privacy Policy'),
          ),

          StudentSettingsSupportSection(
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
                side: const BorderSide(color: Colors.red, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
              ),
              child: Text(
                'Выйти из аккаунта',
                style: AppTextStyles.ttNorms16W600.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
