import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/core/widgets/layout/nav_bar.dart';
import 'package:treemov/features/directory/presentation/screens/student_profile.dart';
import 'package:treemov/features/directory/presentation/widgets/app_bar_title.dart';
import 'package:treemov/features/directory/presentation/widgets/search_field.dart';
import 'package:treemov/features/directory/presentation/widgets/student_item.dart';
import 'package:treemov/shared/data/models/student_group_member_response_model.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';
import 'package:treemov/temp/teacher_screen.dart';

class StudentDirectoryScreen extends StatefulWidget {
  final GroupStudentsResponseModel group;
  final List<GroupStudentsResponseModel> allGroups;
  final List<StudentInGroupResponseModel> initialStudents;

  const StudentDirectoryScreen({
    super.key,
    required this.group,
    required this.allGroups,
    this.initialStudents = const [],
  });

  @override
  State<StudentDirectoryScreen> createState() => _StudentDirectoryScreenState();
}

class _StudentDirectoryScreenState extends State<StudentDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<StudentEntity> _filteredStudents = [];

  List<StudentEntity> _convertToEntities(
    List<StudentInGroupResponseModel> students,
  ) {
    return students.map((item) => item.student.toEntity()).toList();
  }

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
    _filteredStudents = _getSortedStudents(
      _convertToEntities(widget.initialStudents),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      final allStudents = _convertToEntities(widget.initialStudents);

      if (query.isEmpty) {
        _filteredStudents = _getSortedStudents(allStudents);
      } else {
        _filteredStudents = _getSortedStudents(
          allStudents.where((student) {
            final fullName = '${student.name ?? ''} ${student.surname ?? ''}'
                .toLowerCase();
            return fullName.contains(query.toLowerCase());
          }).toList(),
        );
      }
    });
  }

  void _onStudentTap(StudentEntity student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentProfileScreen(
          student: student,
          groupName: widget.group.title ?? 'Группа',
          allGroups: widget.allGroups,
        ),
      ),
    );
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final students = _convertToEntities(widget.initialStudents);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: AppBarTitle(
          text: 'Ученики ${widget.group.title ?? ''}',
          iconPath: 'assets/images/group_icon.png',
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: isDark ? AppColors.darkText : AppColors.grayFieldText,
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Найти ученика...',
          ),
          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Text(
                      'В этой группе нет учеников',
                      style: AppTextStyles.arial14W400.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.directoryTextSecondary,
                      ),
                    ),
                  )
                : _filteredStudents.isEmpty && _searchController.text.isNotEmpty
                ? Center(
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
                          'Студенты не найдены',
                          style: AppTextStyles.ttNorms16W700.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.grayFieldText,
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
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: _filteredStudents
                        .map(
                          (student) => StudentItem(
                            student: student,
                            groupName: widget.group.title ?? 'Группа',
                            onTap: () => _onStudentTap(student),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: _onTabTapped,
      ),
    );
  }
}
