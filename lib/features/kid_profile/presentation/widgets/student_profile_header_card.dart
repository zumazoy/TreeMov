import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/shared/data/models/student_response_model.dart';

class StudentProfileHeaderCard extends StatelessWidget {
  final StudentResponseModel? student;

  const StudentProfileHeaderCard({super.key, required this.student});

  String _getFullName() {
    if (student == null) return 'Ученик';

    final parts = [
      student!.surname,
      student!.name,
      student!.patronymic,
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kidButton.withAlpha(51),
              border: Border.all(color: AppColors.kidButton, width: 1.5),
            ),
            child: CircleAvatar(
              backgroundColor: AppColors.kidButton.withAlpha(51),
              child: Text(
                _getInitials(),
                style: AppTextStyles.ttNorms20W900.copyWith(
                  color: AppColors.kidButton,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFullName(),
                  style: AppTextStyles.ttNorms16W700.copyWith(
                    color: AppColors.notesDarkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  student?.progress ?? 'Ученик',
                  style: AppTextStyles.ttNorms12W400.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials() {
    if (student == null) return '?';
    if (student!.name == null || student!.surname == null) return '?';

    final nameFirst = student!.name!.isNotEmpty ? student!.name![0] : '';
    final surnameFirst = student!.surname!.isNotEmpty
        ? student!.surname![0]
        : '';

    return (nameFirst + surnameFirst).toUpperCase();
  }
}
