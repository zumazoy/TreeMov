import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/features/raiting/presentation/widgets/top_students_chart.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';

class TopStudentsSection extends StatelessWidget {
  final List<StudentEntity> students;

  const TopStudentsSection({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final sortedStudents = [...students]
      ..sort((a, b) => b.score.compareTo(a.score));
    final topThree = _getTopThree(sortedStudents);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (sortedStudents.isNotEmpty)
          Flexible(child: TopStudentsChart(students: topThree))
        else
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Нет данных о студентах',
                style: TextStyle(
                  color: AppColors.achievementDeepBlue,
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<StudentEntity> _getTopThree(List<StudentEntity> sortedStudents) {
    final studentsWithScore = sortedStudents.where((s) => s.score > 0).toList();
    if (studentsWithScore.length < 3) return studentsWithScore;
    return studentsWithScore.take(3).toList();
  }
}
