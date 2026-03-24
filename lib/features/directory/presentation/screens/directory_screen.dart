import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.config.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/features/directory/presentation/bloc/directory_bloc.dart';
import 'package:treemov/features/directory/presentation/screens/student_directory.dart';
import 'package:treemov/features/directory/presentation/widgets/app_bar_title.dart';
import 'package:treemov/features/directory/presentation/widgets/group_item.dart';
import 'package:treemov/features/directory/presentation/widgets/search_field.dart';
import 'package:treemov/shared/data/models/student_group_member_response_model.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DirectoryBloc>()..add(LoadAllGroupsWithCounts()),
      child: const _DirectoryScreenContent(),
    );
  }
}

class _DirectoryScreenContent extends StatefulWidget {
  const _DirectoryScreenContent();

  @override
  State<_DirectoryScreenContent> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<_DirectoryScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  List<GroupStudentsResponseModel> _allGroups = [];
  Map<int, int> _groupStudentCounts = {};
  Map<int, List<StudentInGroupResponseModel>> _groupStudents = {};
  List<GroupStudentsResponseModel> _filteredGroups = [];
  bool _hasSearchQuery = false;

  void _onSearchChanged(String query) {
    setState(() {
      _hasSearchQuery = query.isNotEmpty;

      if (query.isEmpty) {
        _filteredGroups = _allGroups;
      } else {
        _filteredGroups = _allGroups.where((group) {
          return group.title?.toLowerCase().contains(query.toLowerCase()) ==
              true;
        }).toList();
      }
    });
  }

  void _onGroupTap(GroupStudentsResponseModel group) {
    final groupStudents = _groupStudents[group.id] ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDirectoryScreen(
          group: group,
          allGroups: _allGroups,
          initialStudents: groupStudents,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<DirectoryBloc, DirectoryState>(
      listener: (context, state) {
        if (state is GroupsWithCountsLoaded) {
          setState(() {
            _allGroups = state.groups;
            _groupStudentCounts = state.groupStudentCounts;
            _groupStudents = state.groupStudents;
            _filteredGroups = state.groups;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const AppBarTitle(
              text: 'Ученики',
              iconPath: 'assets/images/group_icon.png',
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            foregroundColor: isDark
                ? AppColors.darkText
                : AppColors.grayFieldText,
            centerTitle: false,
            titleSpacing: 0,
            elevation: 0,
          ),
          body: Column(
            children: [
              SearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              Expanded(child: _buildContent(state, isDark)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(DirectoryState state, bool isDark) {
    if (state is DirectoryLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (state is DirectoryError) {
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
              style: AppTextStyles.ttNorms16W700.copyWith(
                color: isDark ? AppColors.darkText : AppColors.grayFieldText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: AppTextStyles.ttNorms14W400.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.directoryTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<DirectoryBloc>().add(LoadAllGroupsWithCounts()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    if (_hasSearchQuery && _filteredGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.directoryTextSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Группы не найдены',
              style: AppTextStyles.ttNorms16W700.copyWith(
                color: isDark ? AppColors.darkText : AppColors.grayFieldText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить поисковый запрос',
              style: AppTextStyles.ttNorms14W400.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.directoryTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (state is GroupsWithCountsLoaded || _allGroups.isNotEmpty) {
      if (_allGroups.isEmpty) {
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
                style: AppTextStyles.ttNorms16W700.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.grayFieldText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Группы появятся после их создания',
                style: AppTextStyles.ttNorms14W400.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.directoryTextSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: _filteredGroups.map((group) {
          final studentCount = group.id != null
              ? _groupStudentCounts[group.id] ?? 0
              : 0;

          return GroupItem(
            groupName: group.title ?? 'Без названия',
            studentCount: studentCount,
            onTap: () => _onGroupTap(group),
          );
        }).toList(),
      );
    }

    return const SizedBox.shrink();
  }
}
