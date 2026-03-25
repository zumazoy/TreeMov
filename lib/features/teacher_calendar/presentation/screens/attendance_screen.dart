import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/core/widgets/layout/nav_bar.dart';
import 'package:treemov/features/teacher_calendar/data/models/attendance_request_model.dart';
import 'package:treemov/features/teacher_calendar/domain/entities/attendance_entity.dart';
import 'package:treemov/features/teacher_calendar/presentation/bloc/schedules_bloc.dart';
import 'package:treemov/features/teacher_calendar/presentation/bloc/schedules_event.dart';
import 'package:treemov/features/teacher_calendar/presentation/bloc/schedules_state.dart';
import 'package:treemov/shared/domain/entities/lesson_entity.dart';
import 'package:treemov/temp/teacher_screen.dart';

import '../widgets/attendance_parts/lesson_info_card.dart';
import '../widgets/attendance_parts/statistics_row.dart';
import '../widgets/attendance_parts/student_card.dart';

class AttendanceScreen extends StatefulWidget {
  final LessonEntity lesson;
  final SchedulesBloc schedulesBloc;

  const AttendanceScreen({
    super.key,
    required this.lesson,
    required this.schedulesBloc,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<AttendanceEntity> _attendances = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    if (widget.lesson.group?.id != null && widget.lesson.id != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      widget.schedulesBloc.add(
        LoadAttendanceEvent(widget.lesson.group!.id!, widget.lesson.id!),
      );
    }
  }

  // Статистика
  int get totalStudents => _attendances.length;
  int get presentCount =>
      _attendances.where((s) => s.wasPresent == true).length;
  int get absentCount =>
      _attendances.where((s) => s.wasPresent == false).length;
  int get notMarkedCount =>
      _attendances.where((s) => s.wasPresent == null).length;

  // Проверка, можно ли сохранять
  bool get canSaveAttendance => notMarkedCount == 0;

  // Получаем данные о занятии из события
  Map<String, dynamic> get _currentLesson {
    final timeParts = widget.lesson
        .formatTime(widget.lesson.startTime, widget.lesson.endTime)
        .split('\n');
    final startTime = timeParts.isNotEmpty ? timeParts[0] : '';
    final endTime = timeParts.length > 1 ? timeParts[1] : '';

    final groupName = widget.lesson.group?.title ?? '';
    final formattedGroup = groupName.isNotEmpty
        ? 'Группа "$groupName"'
        : 'Группа не указана';

    final subjectName = widget.lesson.subject?.title ?? '';
    final formattedSubject = subjectName.isNotEmpty
        ? subjectName
        : 'Предмет не указан';

    final classroomTitle = widget.lesson.classroom?.title ?? '';
    final formattedClassroom = classroomTitle.isNotEmpty
        ? classroomTitle
        : 'Аудитория не указана';

    final formattedTime = startTime.isNotEmpty && endTime.isNotEmpty
        ? '$startTime-$endTime'
        : 'Время не указано';

    return {
      'group': formattedGroup,
      'subject': formattedSubject,
      'time': formattedTime,
      'classroom': formattedClassroom,
    };
  }

  void _markAllPresent() {
    setState(() {
      for (var attendance in _attendances) {
        if (attendance.wasPresent != true) attendance.wasPresent = true;
      }
    });
  }

  void _markPresent(int studentIndex) {
    setState(() {
      final attendance = _attendances.firstWhere(
        (s) => s.index == studentIndex,
      );
      attendance.wasPresent = true;
    });
  }

  void _markAbsent(int studentIndex) {
    setState(() {
      final attendance = _attendances.firstWhere(
        (s) => s.index == studentIndex,
      );
      attendance.wasPresent = false;
    });
  }

  void _saveAttendance() {
    if (!canSaveAttendance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Пожалуйста, отметьте всех студентов перед сохранением ($notMarkedCount не отмечено)',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (widget.lesson.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ID занятия не указан'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final changedAttendances = _attendances
        .where((a) => a.isChanged())
        .toList();

    if (changedAttendances.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Вы ничего не поменяли'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    if (_attendances.any((a) => a.shouldCreate())) {
      final attendanceRequests = _attendances.map((attendance) {
        return AttendanceRequestModel(
          studentId: attendance.student!.id!,
          lessonId: widget.lesson.id!,
          wasPresent: attendance.wasPresent!,
        );
      }).toList();

      widget.schedulesBloc.add(CreateMassAttendanceEvent(attendanceRequests));
    } else {
      final attendanceRequests = {
        for (var attendance in changedAttendances)
          attendance.id!: AttendanceRequestModel(
            wasPresent: attendance.wasPresent!,
          ),
      };

      widget.schedulesBloc.add(PatchMassAttendanceEvent(attendanceRequests));
    }
    Navigator.of(context).pop();
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

  // Сортируем студентов по фамилии и имени
  List<AttendanceEntity> _getSortedStudents() {
    return List.from(_attendances)..sort((a, b) {
      final studentA = a.student;
      final studentB = b.student;

      if (studentA == null || studentB == null) return 0;

      final surnameCompare = (studentA.surname ?? '').compareTo(
        studentB.surname ?? '',
      );
      if (surnameCompare != 0) return surnameCompare;

      return (studentA.name ?? '').compareTo(studentB.name ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final double availableWidth = MediaQuery.of(context).size.width - 40;
    final sortedStudents = _getSortedStudents();

    return BlocListener<SchedulesBloc, ScheduleState>(
      bloc: widget.schedulesBloc,
      listener: (context, state) {
        if (state is AttendanceLoading) {
          setState(() {
            _isLoading = true;
            _errorMessage = null;
          });
        } else if (state is AttendanceLoaded) {
          setState(() {
            _isLoading = false;
            _attendances = state.attendance.asMap().entries.map((entry) {
              final attendance = entry.value;
              final index = entry.key;
              return AttendanceEntity(
                index: index,
                id: attendance.id,
                wasPresent: attendance.wasPresent,
                student: attendance.student,
              );
            }).toList();
          });
        } else if (state is StudentGroupLoaded) {
          setState(() {
            _isLoading = false;
            _attendances = state.studentsInGroup.asMap().entries.map((entry) {
              final studentInGroup = entry.value;
              final index = entry.key;
              return AttendanceEntity(
                index: index,
                id: studentInGroup.id,
                wasPresent: null,
                student: studentInGroup.student,
              );
            }).toList();
          });
        } else if (state is StudentGroupError) {
          setState(() {
            _isLoading = false;
            _errorMessage = state.message;
          });
        } else if (state is AttendanceOperationSuccess) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Посещаемость для "${_currentLesson['subject']}" сохранена',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AttendanceError) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          titleSpacing: 0,
          title: Text(
            'Посещаемость',
            style: AppTextStyles.ttNorms22W900.copyWith(
              color: isDark ? AppColors.darkText : Colors.black,
            ),
          ),
          actions: [
            if (_attendances.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ElevatedButton(
                  onPressed: _markAllPresent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                  ),
                  child: Text(
                    '+ отметить всех',
                    style: AppTextStyles.ttNorms12W600.white,
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Информация о занятии
                LessonInfoCard(
                  lesson: _currentLesson,
                  availableWidth: availableWidth,
                ),
                const SizedBox(height: 20),

                // Статистика
                StatisticsRow(
                  availableWidth: availableWidth,
                  totalStudents: totalStudents,
                  presentCount: presentCount,
                  absentCount: absentCount,
                  notMarkedCount: notMarkedCount,
                ),
                const SizedBox(height: 30),

                Text(
                  'Список обучающихся: ${_attendances.length}',
                  style: AppTextStyles.arial16W700.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grayFieldText,
                  ),
                ),
                const SizedBox(height: 16),

                // Список студентов
                if (_isLoading)
                  _buildLoadingIndicator(theme)
                else if (_errorMessage != null)
                  _buildErrorState(_errorMessage!, isDark)
                else if (_attendances.isEmpty)
                  _buildEmptyState(isDark)
                else
                  Column(
                    children: sortedStudents.map((student) {
                      return StudentCard(
                        student: student,
                        availableWidth: availableWidth,
                        onMarkPresent: () => _markPresent(student.index),
                        onMarkAbsent: () => _markAbsent(student.index),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),

                // Кнопка сохранения
                if (_attendances.isNotEmpty)
                  _buildSaveButton(availableWidth, theme, isDark),
                if (_attendances.isNotEmpty && !canSaveAttendance)
                  _buildSaveHintText(isDark),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 0,
          onTap: _onTabTapped,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return SizedBox(
      height: 100,
      child: Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildErrorState(String message, bool isDark) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ошибка загрузки студентов',
              style: AppTextStyles.ttNorms16W400.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.grayFieldText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.ttNorms12W400.copyWith(
                color: isDark ? AppColors.darkCategoryGeneralText : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          'В группе нет студентов',
          style: AppTextStyles.ttNorms16W400.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.grayFieldText,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(double availableWidth, ThemeData theme, bool isDark) {
    // изменено
    return SizedBox(
      width: availableWidth,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving
            ? null
            : (canSaveAttendance ? _saveAttendance : null),
        style: ElevatedButton.styleFrom(
          backgroundColor: canSaveAttendance && !_isSaving
              ? theme.colorScheme.primary
              : (isDark ? AppColors.darkCard : AppColors.eventTap),
          foregroundColor: canSaveAttendance && !_isSaving
              ? Colors.white
              : theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.5),
          ),
          side: BorderSide(color: theme.colorScheme.primary, width: 1),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        child: _isSaving
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              )
            : Text(
                canSaveAttendance
                    ? 'Сохранить посещаемость'
                    : 'Сохранить ($notMarkedCount не отмечено)',
                style: AppTextStyles.ttNorms16W600.copyWith(
                  color: canSaveAttendance
                      ? Colors.white
                      : theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  Widget _buildSaveHintText(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: Text(
          'Отметьте всех, чтобы сохранить',
          style: AppTextStyles.ttNorms14W400.copyWith(
            color: isDark ? AppColors.darkTextSecondary : Colors.black,
          ),
        ),
      ),
    );
  }
}
