import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.config.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/features/raiting/presentation/blocs/rating_bloc.dart';
import 'package:treemov/features/raiting/presentation/blocs/rating_event.dart';
import 'package:treemov/features/raiting/presentation/blocs/rating_state.dart';
import 'package:treemov/features/raiting/presentation/widgets/group_selector.dart';
import 'package:treemov/features/raiting/presentation/widgets/loading_error_widgets.dart';
import 'package:treemov/features/raiting/presentation/widgets/rating_app_bar.dart';
import 'package:treemov/features/raiting/presentation/widgets/rating_background.dart';
import 'package:treemov/features/raiting/presentation/widgets/students_draggable_sheet.dart';
import 'package:treemov/features/raiting/presentation/widgets/top_students_section.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  late RatingBloc _ratingBloc;
  bool _showPinnedCard = true;

  @override
  void initState() {
    super.initState();
    _ratingBloc = getIt<RatingBloc>();
    _loadData();
  }

  void _loadData() {
    _ratingBloc.add(const LoadStudentGroupsEvent());
    _ratingBloc.add(const LoadCurrentStudentEvent());
  }

  @override
  void dispose() {
    _ratingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RatingBloc>.value(
      value: _ratingBloc,
      child: BlocBuilder<RatingBloc, RatingState>(
        builder: (context, state) {
          if (state is StudentsLoaded) {
            return _buildContent(state);
          } else if (state is RatingError) {
            return _buildErrorContent();
          } else if (state is RatingLoading) {
            return const RatingLoadingWidget();
          }
          return const RatingLoadingWidget();
        },
      ),
    );
  }

  Widget _buildErrorContent() {
    return Scaffold(
      backgroundColor: AppColors.skyBlue,
      body: RatingBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sentiment_dissatisfied_outlined,
                size: 64,
                color: Colors.white70,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ой, кажется что-то пошло не так',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Попробуйте обновить экран',
                style: TextStyle(
                  color: Colors.white.withAlpha(179),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.achievementDeepBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Обновить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(StudentsLoaded state) {
    final sortedStudents = [...state.students]
      ..sort((a, b) => b.score.compareTo(a.score));
    final currentUserPosition = _getCurrentUserPosition(
      sortedStudents,
      state.currentStudent,
    );

    return Scaffold(
      backgroundColor: AppColors.skyBlue,
      body: RatingBackground(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                if (state.selectedGroup != null) {
                  _ratingBloc.add(
                    LoadStudentsForGroupEvent(state.selectedGroup!),
                  );
                } else {
                  _loadData();
                }
                await Future.delayed(const Duration(milliseconds: 500));
              },
              color: AppColors.achievementDeepBlue,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const RatingAppBar(),
                        if (state.groups.isNotEmpty)
                          GroupSelector(
                            groups: state.groups,
                            selectedGroup: state.selectedGroup,
                            onGroupSelected: (group) {
                              _ratingBloc.add(ChangeGroupEvent(group));
                            },
                          ),
                        const SizedBox(height: 16),
                        TopStudentsSection(students: sortedStudents),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (sortedStudents.isNotEmpty)
              StudentsDraggableSheet(
                students: sortedStudents,
                currentStudent: state.currentStudent,
                currentUserPosition: currentUserPosition,
                showPinnedCard: _showPinnedCard,
                onPinnedCardVisibilityChanged: (visible) {
                  if (mounted) {
                    setState(() {
                      _showPinnedCard = visible;
                    });
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  int _getCurrentUserPosition(
    List<StudentEntity> sortedStudents,
    StudentEntity? currentStudent,
  ) {
    if (currentStudent == null) return 0;
    final index = sortedStudents.indexWhere(
      (student) => student.id == currentStudent.id,
    );
    return index != -1 ? index + 1 : 0;
  }
}
