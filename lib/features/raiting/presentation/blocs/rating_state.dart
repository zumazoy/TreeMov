import 'package:treemov/shared/data/models/student_group_response_model.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';

abstract class RatingState {
  const RatingState();
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingEmpty extends RatingState {
  final String message;

  const RatingEmpty(this.message);
}

class StudentGroupsLoaded extends RatingState {
  final List<GroupStudentsResponseModel> groups;
  final GroupStudentsResponseModel? selectedGroup;

  const StudentGroupsLoaded({required this.groups, this.selectedGroup});
}

class StudentsLoaded extends RatingState {
  final List<StudentEntity> students;
  final List<GroupStudentsResponseModel> groups;
  final GroupStudentsResponseModel? selectedGroup;
  final StudentEntity? currentStudent;

  const StudentsLoaded({
    required this.students,
    required this.groups,
    this.selectedGroup,
    this.currentStudent,
  });
}

class RatingError extends RatingState {
  final String message;

  const RatingError(this.message);
}
