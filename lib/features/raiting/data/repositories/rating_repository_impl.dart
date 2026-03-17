import 'package:shared_preferences/shared_preferences.dart';
import 'package:treemov/features/raiting/data/datasource/rating_remote_data_source.dart';
import 'package:treemov/features/raiting/domain/repositories/rating_repository.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource _remoteDataSource;

  RatingRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<StudentEntity>> getStudents() async {
    try {
      final students = await _remoteDataSource.getAllStudents();
      final entities = students.map((s) => s.toEntity()).toList();
      entities.sort((a, b) => b.score.compareTo(a.score));
      return entities;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<StudentEntity>> getStudentsByGroup(int groupId) async {
    try {
      final students = await _remoteDataSource.getStudentsByGroup(groupId);
      final entities = students.map((s) => s.toEntity()).toList();
      entities.sort((a, b) => b.score.compareTo(a.score));
      return entities;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<StudentEntity?> getCurrentStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final currentStudentId = prefs.getInt('current_student_id');
    if (currentStudentId == null) return null;

    final students = await getStudents();
    try {
      return students.firstWhere((student) => student.id == currentStudentId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GroupStudentsResponseModel>> getStudentGroups() async {
    try {
      return await _remoteDataSource.getStudentGroups();
    } catch (e) {
      return [];
    }
  }

  Future<void> setCurrentStudentId(int studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_student_id', studentId);
  }

  Future<void> clearCurrentStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_student_id');
  }
}
