import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';

import '../../domain/repositories/rating_repository.dart';
import 'rating_event.dart';
import 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository _repository;
  List<GroupStudentsResponseModel> _groups = [];
  GroupStudentsResponseModel? _selectedGroup;

  RatingBloc(this._repository) : super(RatingInitial()) {
    on<LoadStudentGroupsEvent>(_onLoadStudentGroups);
    on<LoadStudentsForGroupEvent>(_onLoadStudentsForGroup);
    on<LoadCurrentStudentEvent>(_onLoadCurrentStudent);
    on<ChangeGroupEvent>(_onChangeGroup);
  }

  Future<void> _onLoadStudentGroups(
    LoadStudentGroupsEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    try {
      _groups = await _repository.getStudentGroups();

      if (_groups.isEmpty) {
        emit(const RatingEmpty('Упс, кажется тут нет групп'));
        return;
      }

      _selectedGroup = _groups.first;

      if (_selectedGroup!.id != null) {
        final students = await _repository.getStudentsByGroup(
          _selectedGroup!.id!,
        );
        final currentStudent = await _repository.getCurrentStudent();
        emit(
          StudentsLoaded(
            students: students,
            groups: _groups,
            selectedGroup: _selectedGroup,
            currentStudent: currentStudent,
          ),
        );
      } else {
        final students = await _repository.getStudents();
        final currentStudent = await _repository.getCurrentStudent();
        emit(
          StudentsLoaded(
            students: students,
            groups: _groups,
            selectedGroup: _selectedGroup,
            currentStudent: currentStudent,
          ),
        );
      }
    } catch (e) {
      emit(const RatingError('Что-то пошло не так'));
    }
  }

  Future<void> _onLoadStudentsForGroup(
    LoadStudentsForGroupEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    try {
      if (event.group.id != null) {
        final students = await _repository.getStudentsByGroup(event.group.id!);
        final currentStudent = await _repository.getCurrentStudent();
        emit(
          StudentsLoaded(
            students: students,
            groups: _groups,
            selectedGroup: event.group,
            currentStudent: currentStudent,
          ),
        );
      } else {
        emit(const RatingError('Что-то пошло не так'));
      }
    } catch (e) {
      emit(const RatingError('Что-то пошло не так'));
    }
  }

  Future<void> _onLoadCurrentStudent(
    LoadCurrentStudentEvent event,
    Emitter<RatingState> emit,
  ) async {
    try {
      final currentStudent = await _repository.getCurrentStudent();

      if (state is StudentsLoaded) {
        final currentState = state as StudentsLoaded;
        emit(
          StudentsLoaded(
            students: currentState.students,
            groups: currentState.groups,
            selectedGroup: currentState.selectedGroup,
            currentStudent: currentStudent,
          ),
        );
      }
    } catch (e) {
      // Игнорируем ошибку
    }
  }

  Future<void> _onChangeGroup(
    ChangeGroupEvent event,
    Emitter<RatingState> emit,
  ) async {
    _selectedGroup = event.group;
    add(LoadStudentsForGroupEvent(event.group));
  }
}
