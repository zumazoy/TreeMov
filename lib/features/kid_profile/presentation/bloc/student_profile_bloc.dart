import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:treemov/features/kid_profile/domain/repositories/student_profile_repository.dart';
import 'package:treemov/shared/data/models/accrual_response_model.dart';
import 'package:treemov/shared/data/models/student_response_model.dart';

part 'student_profile_event.dart';
part 'student_profile_state.dart';

class StudentProfileBloc
    extends Bloc<StudentProfileEvent, StudentProfileState> {
  final StudentProfileRepository _studentProfileRepository;

  StudentProfileBloc(this._studentProfileRepository)
    : super(StudentProfileState.initial()) {
    on<LoadStudentProfile>(_onLoadStudentProfile);
    on<LoadStudentActivities>(_onLoadStudentActivities);
  }

  Future<void> _onLoadStudentProfile(
    LoadStudentProfile event,
    Emitter<StudentProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingProfile: true, profileError: null));
    try {
      final studentProfile = await _studentProfileRepository
          .getStudentProfile();
      emit(
        state.copyWith(studentProfile: studentProfile, isLoadingProfile: false),
      );

      if (studentProfile.id != null) {
        add(LoadStudentActivities());
      }
    } catch (e) {
      emit(state.copyWith(isLoadingProfile: false, profileError: e.toString()));
    }
  }

  Future<void> _onLoadStudentActivities(
    LoadStudentActivities event,
    Emitter<StudentProfileState> emit,
  ) async {
    final studentId = state.studentProfile?.id;

    if (studentId == null) {
      emit(
        state.copyWith(
          activitiesError: 'ID ученика не найден',
          isLoadingActivities: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoadingActivities: true, activitiesError: null));

    try {
      final allActivities = await _studentProfileRepository.getStudentAccruals(
        studentId: studentId,
        page: 1,
      );

      final filteredActivities = allActivities.where((accrual) {
        return accrual.student?.id == studentId;
      }).toList();

      final sortedActivities =
          List<AccrualResponseModel>.from(filteredActivities)..sort((a, b) {
            if (a.createdAt == null && b.createdAt == null) return 0;
            if (a.createdAt == null) return 1;
            if (b.createdAt == null) return -1;

            return b.createdAt!.compareTo(a.createdAt!);
          });

      final lastTenActivities = sortedActivities.take(10).toList();

      emit(
        state.copyWith(
          activities: lastTenActivities,
          isLoadingActivities: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingActivities: false,
          activitiesError: e.toString(),
        ),
      );
    }
  }
}
