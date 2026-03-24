import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.config.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/features/kid_profile/presentation/bloc/student_profile_bloc.dart';
import 'package:treemov/features/kid_profile/presentation/screens/student_settings_screen.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/activity_converter.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/activity_section_widget.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/level_progress_widget.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/profile_header_widget.dart';
import 'package:treemov/features/kid_profile/presentation/widgets/stats_row_widget.dart';
import 'package:treemov/shared/data/models/student_response_model.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentProfileBloc>()
        ..add(LoadStudentProfile())
        ..add(LoadStudentActivities()),
      child: const _StudentProfileContent(),
    );
  }
}

class _StudentProfileContent extends StatelessWidget {
  const _StudentProfileContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentProfileBloc, StudentProfileState>(
      builder: (context, state) {
        if (state.isLoadingProfile && state.studentProfile == null) {
          return const Scaffold(
            backgroundColor: AppColors.kidPrimary,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.profileError != null && state.studentProfile == null) {
          return Scaffold(
            backgroundColor: AppColors.kidPrimary,
            appBar: _buildAppBar(context, state),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ошибка: ${state.profileError}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StudentProfileBloc>().add(
                        LoadStudentProfile(),
                      );
                    },
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.kidPrimary,
          appBar: _buildAppBar(context, state),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCEEFFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              ProfileHeaderWidget(
                                name: _getFullName(state.studentProfile),
                                level: _calculateLevel(state.currentPoints),
                                levelTitle: _getLevelTitle(
                                  _calculateLevel(state.currentPoints),
                                ),
                                currentPoints: state.currentPoints,
                              ),
                              const SizedBox(height: 8),
                              LevelProgressWidget(
                                currentExp: state.currentPoints % 100,
                                nextLevelExp: 100,
                              ),
                              const SizedBox(height: 16),
                              StatsRowWidget(
                                totalEarnings: state.totalEarnings,
                                attendance: 95,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ActivitySectionWidget(
                            activities: state.activities
                                .map((a) => ActivityConverter.fromAccrual(a))
                                .toList(),
                            isLoading: state.isLoadingActivities,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, StudentProfileState state) {
    return AppBar(
      backgroundColor: AppColors.kidPrimary,
      elevation: 0,
      title: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF19BCDB), Color(0xFF741CDB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: Text('TreeMov', style: AppTextStyles.ttNorms20W700.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    StudentSettingsScreen(studentProfile: state.studentProfile),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getFullName(StudentResponseModel? student) {
    if (student == null) return 'Ученик';
    final parts = [
      student.surname,
      student.name,
      student.patronymic,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(' ');
  }

  int _calculateLevel(int points) {
    return (points / 100).floor() + 1;
  }

  String _getLevelTitle(int level) {
    switch (level) {
      case 1:
        return 'Новичок';
      case 2:
        return 'Исследователь';
      case 3:
        return 'Опытный';
      case 4:
        return 'Эксперт';
      case 5:
        return 'Мастер';
      default:
        return 'Легенда';
    }
  }
}
