import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/core/widgets/layout/nav_bar.dart';
import 'package:treemov/features/accrual_points/presentation/bloc/accrual_bloc.dart';
import 'package:treemov/shared/data/models/student_group_member_response_model.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';
import 'package:treemov/temp/main_screen.dart';

import '../../../directory/presentation/widgets/search_field.dart';
import '../../domain/entities/point_category_entity.dart';
import '../widgets/action_selection_dialog.dart';
import '../widgets/points_snackbar.dart';
import '../widgets/student_avatar.dart';

class StudentsPointsListScreen extends StatefulWidget {
  final GroupStudentsResponseModel group;
  final List<StudentInGroupResponseModel> initialStudents;
  final AccrualBloc accrualBloc;

  const StudentsPointsListScreen({
    super.key,
    required this.group,
    required this.initialStudents,
    required this.accrualBloc,
  });

  @override
  State<StudentsPointsListScreen> createState() =>
      _StudentsPointsListScreenState();
}

class _StudentsPointsListScreenState extends State<StudentsPointsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<StudentEntity> _students = [];
  List<StudentEntity> _filteredStudents = [];
  bool _hasSearchQuery = false;

  List<StudentEntity> _getSortedStudents(List<StudentEntity> students) {
    students.sort((a, b) {
      final aSurname = a.surname ?? '';
      final bSurname = b.surname ?? '';
      final aName = a.name ?? '';
      final bName = b.name ?? '';

      final surnameCompare = aSurname.toLowerCase().compareTo(
        bSurname.toLowerCase(),
      );
      if (surnameCompare != 0) return surnameCompare;
      return aName.toLowerCase().compareTo(bName.toLowerCase());
    });
    return students;
  }

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    _students = widget.initialStudents
        .map((item) => item.student.toEntity())
        .toList();
    _filteredStudents = _getSortedStudents(List.from(_students));
  }

  void _applySearchFilter() {
    final query = _searchController.text;
    if (query.isEmpty) {
      _filteredStudents = _getSortedStudents(List.from(_students));
    } else {
      _filteredStudents = _getSortedStudents(
        _students.where((student) {
          final fullName = '${student.name ?? ''} ${student.surname ?? ''}'
              .toLowerCase();
          return fullName.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _hasSearchQuery = query.isNotEmpty;
      _applySearchFilter();
    });
  }

  void _showActionSelectionDialog(StudentEntity student) {
    showDialog(
      context: context,
      builder: (context) => ActionSelectionDialog(
        student: student,
        accrualBloc: widget.accrualBloc,
      ),
    ).then((selectedAction) {
      if (selectedAction != null) {
        _showConfirmationScreen(student, selectedAction);
      }
    });
  }

  void _showConfirmationScreen(StudentEntity student, PointAction action) {
    PointsSnackBar.show(context: context, student: student, action: action);
  }

  void _onTabTapped(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherScreen(initialIndex: index),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AccrualBloc, AccrualState>(
      bloc: widget.accrualBloc,
      listener: (context, state) {
        if (state is GroupsLoaded) {
          // Когда приходят обновленные группы, обновляем список студентов для текущей группы
          final updatedStudents = state.groupStudents[widget.group.baseData.id];
          if (updatedStudents != null) {
            setState(() {
              _students = updatedStudents
                  .map(
                    (item) => (item as StudentInGroupResponseModel).student
                        .toEntity(),
                  )
                  .toList();
              _applySearchFilter();
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
        appBar: AppBar(
          title: Text(
            widget.group.title ?? 'Группа',
            style: AppTextStyles.arial18W700.themed(context),
          ),
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.darkText : AppColors.notesDarkText,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            SearchField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: 'Поиск ученика...',
            ),
            Expanded(child: _buildContent()),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1,
          onTap: _onTabTapped,
        ),
      ),
    );
  }

  Widget _buildContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_hasSearchQuery && _filteredStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 64,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.directoryTextSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Ученики не найдены',
              style: AppTextStyles.arial16W700.themed(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить поисковый запрос',
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

    if (_students.isEmpty) {
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
              'В группе нет учеников',
              style: AppTextStyles.arial16W700.themed(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте учеников в группу',
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];
        return _buildStudentCard(context, student);
      },
    );
  }

  Widget _buildStudentCard(BuildContext context, StudentEntity student) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
          StudentAvatar(avatarUrl: null),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.name ?? ''} ${student.surname ?? ''}',
                  style: AppTextStyles.arial16W700.themed(context),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/energy_icon.png',
                      width: 16,
                      height: 16,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.directoryTextSecondary,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.bolt,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.directoryTextSecondary,
                          size: 16,
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${student.score} баллов',
                      style: AppTextStyles.arial12W400.copyWith(
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

          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.teacherPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: () => _showActionSelectionDialog(student),
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              label: Text('Начислить', style: AppTextStyles.arial12W400.white),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
