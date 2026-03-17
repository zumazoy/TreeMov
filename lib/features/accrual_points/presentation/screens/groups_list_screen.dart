import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.config.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/features/accrual_points/presentation/bloc/accrual_bloc.dart';
import 'package:treemov/shared/data/models/student_group_member_response_model.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';

import 'students_points_list_screen.dart';

class GroupsListScreen extends StatelessWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccrualBloc>()..add(LoadStudentGroups()),
      child: const _GroupsListScreenContent(),
    );
  }
}

class _GroupsListScreenContent extends StatefulWidget {
  const _GroupsListScreenContent();

  @override
  State<_GroupsListScreenContent> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<_GroupsListScreenContent> {
  List<GroupStudentsResponseModel> _groups = [];
  Map<int, int> _groupStudentCounts = {};
  Map<int, List<StudentInGroupResponseModel>> _groupStudents = {};

  void _onGroupTap(GroupStudentsResponseModel group, BuildContext context) {
    final accrualBloc = context.read<AccrualBloc>();
    final groupStudents = _groupStudents[group.baseData.id] ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: accrualBloc,
          child: StudentsPointsListScreen(
            group: group,
            initialStudents: groupStudents,
            accrualBloc: accrualBloc,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AccrualBloc, AccrualState>(
      listener: (context, state) {
        if (state is GroupsLoaded) {
          setState(() {
            _groups = state.groups;
            _groupStudentCounts = state.groupStudentCounts;
            _groupStudents = {
              for (var e in state.groupStudents.entries)
                e.key: e.value as List<StudentInGroupResponseModel>,
            };
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/stars_filled_icon.png',
                  width: 24,
                  height: 24,
                  color: isDark ? AppColors.darkText : null,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.star,
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.notesDarkText,
                      size: 24,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'Журнал',
                  style: AppTextStyles.arial20W700.themed(context),
                ),
              ],
            ),
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.white,
            elevation: 0,
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Выберите группу для начисления баллов:',
                  style: AppTextStyles.arial16W400.themed(context),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AccrualState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state is AccrualLoading && _groups.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.teacherPrimary),
        ),
      );
    }

    if (state is AccrualError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.directoryTextSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Ошибка загрузки',
              style: AppTextStyles.arial16W700.themed(context),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: AppTextStyles.arial14W400.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.directoryTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<AccrualBloc>().add(LoadStudentGroups()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teacherPrimary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    if (_groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 64,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.directoryTextSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет доступных групп',
              style: AppTextStyles.arial16W700.themed(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Группы появятся после их создания',
              style: AppTextStyles.arial14W400.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.directoryTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        final studentCount = _groupStudentCounts[group.baseData.id] ?? 0;

        return _buildGroupItem(context, group, studentCount);
      },
    );
  }

  Widget _buildGroupItem(
    BuildContext context,
    GroupStudentsResponseModel group,
    int studentCount,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _onGroupTap(group, context),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          border: Border.all(
            color: isDark ? AppColors.darkSurface : AppColors.directoryBorder,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.title ?? 'Без названия',
                    style: AppTextStyles.arial16W700.themed(context),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/team_icon.png',
                        width: 16,
                        height: 16,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.directoryTextSecondary,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.people,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.directoryTextSecondary,
                            size: 16,
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$studentCount учеников',
                        style: AppTextStyles.arial14W400.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.directoryTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/purple_arrow.png',
              width: 24,
              height: 24,
              color: isDark ? AppColors.darkText : null,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.arrow_forward_ios,
                  color: isDark
                      ? AppColors.darkText
                      : AppColors.directoryTextSecondary,
                  size: 20,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
