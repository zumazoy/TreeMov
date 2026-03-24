import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';

class TopStudentsChart extends StatelessWidget {
  final List<StudentEntity> students;

  const TopStudentsChart({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isMediumScreen = screenSize.width >= 360 && screenSize.width < 600;
    final isTablet = screenSize.width >= 600;

    final studentsWithScore = students.where((s) => s.score > 0).toList();

    if (studentsWithScore.length < 3) {
      return _buildChartForAvailableStudents(studentsWithScore, screenSize);
    }

    final topThreeStudents = studentsWithScore
      ..sort((a, b) => b.score.compareTo(a.score))
      ..sublist(0, 3);

    final maxScore = topThreeStudents.first.score.toDouble();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 0 : 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: isTablet ? 350 : (isMediumScreen ? 300 : 280),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final spacing = availableWidth * 0.05;

                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      left: spacing,
                      bottom: 25,
                      child: _buildChartWithAvatar(
                        topThreeStudents[1],
                        2,
                        maxScore,
                        isSmallScreen,
                        isMediumScreen,
                        isTablet,
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      child: _buildChartWithAvatar(
                        topThreeStudents[0],
                        1,
                        maxScore,
                        isSmallScreen,
                        isMediumScreen,
                        isTablet,
                      ),
                    ),
                    Positioned(
                      right: spacing,
                      bottom: 25,
                      child: _buildChartWithAvatar(
                        topThreeStudents[2],
                        3,
                        maxScore,
                        isSmallScreen,
                        isMediumScreen,
                        isTablet,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartForAvailableStudents(
    List<StudentEntity> studentsWithScore,
    Size screenSize,
  ) {
    final isSmallScreen = screenSize.width < 360;
    final isMediumScreen = screenSize.width >= 360 && screenSize.width < 600;

    if (studentsWithScore.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Нет данных для отображения',
            style: TextStyle(
              color: AppColors.achievementDeepBlue,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final sortedStudents = [...studentsWithScore]
      ..sort((a, b) => b.score.compareTo(a.score));
    final maxScore = sortedStudents.first.score.toDouble();
    final studentCount = sortedStudents.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: isMediumScreen ? 280 : 260,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (studentCount == 1) ...[
                  Positioned(
                    bottom: 0,
                    child: _buildChartWithAvatar(
                      sortedStudents[0],
                      1,
                      maxScore,
                      isSmallScreen,
                      isMediumScreen,
                      false,
                    ),
                  ),
                ] else if (studentCount == 2) ...[
                  Positioned(
                    left: screenSize.width * 0.1,
                    bottom: 0,
                    child: _buildChartWithAvatar(
                      sortedStudents[0],
                      1,
                      maxScore,
                      isSmallScreen,
                      isMediumScreen,
                      false,
                    ),
                  ),
                  Positioned(
                    right: screenSize.width * 0.1,
                    bottom: 0,
                    child: _buildChartWithAvatar(
                      sortedStudents[1],
                      2,
                      maxScore,
                      isSmallScreen,
                      isMediumScreen,
                      false,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartWithAvatar(
    StudentEntity student,
    int position,
    double maxScore,
    bool isSmallScreen,
    bool isMediumScreen,
    bool isTablet,
  ) {
    final chartHeight = _calculateChartHeight(student.score, maxScore);

    final width = _getChartWidth(
      position,
      isSmallScreen,
      isMediumScreen,
      isTablet,
    );
    final avatarRadius = _getAvatarRadius(
      isSmallScreen,
      isMediumScreen,
      isTablet,
    );
    final fontSize = _getFontSize(isSmallScreen, isMediumScreen, isTablet);
    final scoreFontSize = _getScoreFontSize(
      isSmallScreen,
      isMediumScreen,
      isTablet,
    );
    final iconSize = _getIconSize(isSmallScreen, isMediumScreen, isTablet);
    final nameFontSize = _getNameFontSize(
      isSmallScreen,
      isMediumScreen,
      isTablet,
    );
    final nameMaxLines = _getNameMaxLines(
      isSmallScreen,
      isMediumScreen,
      isTablet,
    );
    final padding = _getPadding(isSmallScreen, isMediumScreen, isTablet);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: Offset(0, isSmallScreen ? -5 : -8),
          child: Stack(
            children: [
              CircleAvatar(
                radius: avatarRadius.toDouble(),
                backgroundColor: AppColors.achievementDeepBlue,
                child: Text(
                  student.initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize.toDouble(),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 3 : 4),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 253, 253, 253),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    position.toString(),
                    style: TextStyle(
                      color: const Color.fromARGB(255, 57, 119, 199),
                      fontSize: isSmallScreen ? 10 : 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: width.toDouble(),
          height: chartHeight,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(128),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Tooltip(
                  message: student.fullName,
                  child: Text(
                    student.fullName,
                    textAlign: TextAlign.center,
                    maxLines: nameMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.achievementDeepBlue,
                      fontSize: nameFontSize.toDouble(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    student.score.toString(),
                    style: TextStyle(
                      color: AppColors.achievementDeepBlue,
                      fontSize: scoreFontSize.toDouble(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.bolt,
                    color: AppColors.achievementDeepBlue,
                    size: iconSize.toDouble(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getChartWidth(
    int position,
    bool isSmallScreen,
    bool isMediumScreen,
    bool isTablet,
  ) {
    if (isTablet) {
      return position == 1 ? 180 : 160;
    } else if (isMediumScreen) {
      return position == 1 ? 140 : 120;
    } else if (isSmallScreen) {
      return position == 1 ? 100 : 85;
    }
    return position == 1 ? 130 : 110;
  }

  double _getAvatarRadius(
    bool isSmallScreen,
    bool isMediumScreen,
    bool isTablet,
  ) {
    if (isTablet) return 44;
    if (isMediumScreen) return 38;
    if (isSmallScreen) return 30;
    return 36;
  }

  double _getFontSize(bool isSmallScreen, bool isMediumScreen, bool isTablet) {
    if (isTablet) return 16;
    if (isMediumScreen) return 14;
    if (isSmallScreen) return 12;
    return 14;
  }

  double _getScoreFontSize(
    bool isSmallScreen,
    bool isMediumScreen,
    bool isTablet,
  ) {
    if (isTablet) return 18;
    if (isMediumScreen) return 16;
    if (isSmallScreen) return 14;
    return 16;
  }

  double _getIconSize(bool isSmallScreen, bool isMediumScreen, bool isTablet) {
    if (isTablet) return 20;
    if (isMediumScreen) return 18;
    if (isSmallScreen) return 16;
    return 18;
  }

  double _getNameFontSize(
    bool isSmallScreen,
    bool isMediumScreen,
    bool isTablet,
  ) {
    if (isTablet) return 14;
    if (isMediumScreen) return 11;
    if (isSmallScreen) return 9;
    return 12;
  }

  int _getNameMaxLines(bool isSmallScreen, bool isMediumScreen, bool isTablet) {
    if (isTablet) return 2;
    if (isMediumScreen) return 2;
    if (isSmallScreen) return 1;
    return 2;
  }

  double _getPadding(bool isSmallScreen, bool isMediumScreen, bool isTablet) {
    if (isTablet) return 12;
    if (isMediumScreen) return 8;
    if (isSmallScreen) return 6;
    return 10;
  }

  double _calculateChartHeight(int studentScore, double maxScore) {
    const double minHeight = 50.0;
    const double maxHeight = 130.0;

    if (maxScore == 0) return minHeight;

    final double percentage = studentScore / maxScore;
    final double adjustedHeight =
        minHeight + (percentage * (maxHeight - minHeight));
    return adjustedHeight.clamp(minHeight, maxHeight);
  }
}
