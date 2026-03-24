import 'package:flutter/material.dart';
import 'package:treemov/features/raiting/presentation/widgets/draggable_sheet_handler.dart';
import 'package:treemov/features/raiting/presentation/widgets/pinned_student_card.dart';
import 'package:treemov/features/raiting/presentation/widgets/student_card.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';

class StudentsDraggableSheet extends StatelessWidget {
  final List<StudentEntity> students;
  final StudentEntity? currentStudent;
  final int currentUserPosition;
  final bool showPinnedCard;
  final Function(bool) onPinnedCardVisibilityChanged;

  const StudentsDraggableSheet({
    super.key,
    required this.students,
    required this.currentStudent,
    required this.currentUserPosition,
    required this.showPinnedCard,
    required this.onPinnedCardVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return DraggableScrollableSheet(
      initialChildSize: isSmallScreen ? 0.5 : 0.45,
      minChildSize: isSmallScreen ? 0.5 : 0.45,
      maxChildSize: isSmallScreen ? 0.9 : 0.87,
      snap: true,
      snapSizes: isSmallScreen ? const [0.5, 0.85] : const [0.45, 0.85],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (currentStudent != null &&
                  students.any((s) => s.id == currentStudent!.id)) {
                _handleScrollNotification(notification, context);
              }
              return false;
            },
            child: Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(child: const DraggableSheetHandler()),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final student = students[index];
                        final position = index + 1;
                        final isCurrentUser =
                            currentStudent != null &&
                            student.id == currentStudent!.id;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04,
                            vertical: 4,
                          ),
                          child: StudentCard(
                            student: student,
                            position: position,
                            isCurrentUser: isCurrentUser,
                          ),
                        );
                      }, childCount: students.length),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height:
                            currentStudent != null &&
                                students.any((s) => s.id == currentStudent!.id)
                            ? (isSmallScreen ? 60 : 80)
                            : 0,
                      ),
                    ),
                  ],
                ),
                if (showPinnedCard && currentStudent != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: PinnedStudentCard(
                      student: currentStudent!,
                      position: currentUserPosition,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleScrollNotification(
    ScrollNotification notification,
    BuildContext context,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final itemHeight = isSmallScreen ? 68.0 : 72.0;

    final scrollOffset = notification.metrics.pixels;
    final viewportHeight = notification.metrics.viewportDimension;

    final userPosition = (currentUserPosition - 1) * itemHeight;
    final userIsAboveViewport = userPosition + itemHeight <= scrollOffset;
    final userIsBelowViewport = userPosition >= scrollOffset + viewportHeight;
    final shouldShowPinned = userIsAboveViewport || userIsBelowViewport;

    if (showPinnedCard != shouldShowPinned) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onPinnedCardVisibilityChanged(shouldShowPinned);
      });
    }
  }
}
