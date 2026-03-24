import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.config.dart';
import 'package:treemov/features/teacher_profile/presentation/bloc/teacher_profile_bloc.dart';
import 'package:treemov/features/teacher_profile/presentation/screens/settings_screen.dart';
import 'package:treemov/shared/data/models/org_member_response_model.dart';

import '../widgets/daily_schedule_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/rep_nots_buttons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        return getIt<TeacherProfileBloc>()
          ..add(LoadTeacherProfile())
          ..add(LoadLessons(today, today));
      },
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  // void _showSettingsMenu(
  //   BuildContext context,
  //   TeacherProfileResponseModel? teacherProfile,
  // ) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         alignment: Alignment.topRight,
  //         insetPadding: const EdgeInsets.only(top: 60, right: 16),
  //         child: SettingsMenu(
  //           onEditData: () {
  //             Navigator.pop(context);
  //           },
  //           onChangePassword: () {
  //             Navigator.pop(context);
  //           },
  //           onSettings: () {
  //             Navigator.pop(context);
  //             if (teacherProfile != null) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) =>
  //                       SettingsScreen(teacherProfile: teacherProfile),
  //                 ),
  //               );
  //             }
  //           },
  //           onLogout: () {
  //             Navigator.pop(context);
  //             LogoutDialog.show(context: context);
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TeacherProfileBloc, TeacherProfileState>(
      builder: (context, state) {
        // Показываем индикатор загрузки только если нет данных профиля и идет загрузка
        if (state.isLoadingProfile && state.teacherProfile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Обработка ошибки профиля (если нет данных профиля)
        if (state.profileError != null && state.teacherProfile == null) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(context, null),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ошибка: ${state.profileError}',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<TeacherProfileBloc>().add(
                      LoadTeacherProfile(),
                    ),
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            ),
          );
        }

        // Если есть данные профиля, показываем экран
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: _buildAppBar(context, state.teacherProfile),
          body: Column(
            children: [
              if (state.teacherProfile != null)
                ProfileHeader(orgMember: state.teacherProfile!),

              Container(height: 1, color: theme.dividerColor),
              const SizedBox(height: 15),

              Expanded(child: _buildLessonsContent(context, state)),

              Container(
                padding: const EdgeInsets.all(16),
                color: theme.scaffoldBackgroundColor,
                child: RepNotsButtons(),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    OrgMemberResponseModel? teacherProfile,
  ) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      title: Image.asset(
        'assets/images/grad_logo.png',
        height: 30,
        fit: BoxFit.contain,
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/images/gear_icon.png',
            width: 20,
            height: 20,
            color: theme.iconTheme.color,
          ),
          onPressed: () => {
            // if (teacherProfile != null)
            //   {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(orgMember: teacherProfile),
              ),
            ),
            // },
          },
        ),
      ],
    );
  }

  Widget _buildLessonsContent(BuildContext context, TeacherProfileState state) {
    final theme = Theme.of(context);

    // Загрузка уроков
    if (state.isLoadingLessons) {
      return const Center(child: CircularProgressIndicator());
    }

    // Ошибка загрузки уроков
    if (state.lessonsError != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ошибка загрузки расписания: ${state.lessonsError}',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            ElevatedButton(
              onPressed: () => context.read<TeacherProfileBloc>().add(
                LoadLessons(today, today),
              ),
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    // Уроки загружены
    if (state.lessons != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DailyScheduleCard(todayLessons: state.lessons!),
            const SizedBox(height: 32),
          ],
        ),
      );
    }

    // Если уроки еще не загружены (но профиль уже есть)
    return const Center(child: CircularProgressIndicator());
  }
}
