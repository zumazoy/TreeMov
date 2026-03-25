import 'package:flutter/material.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';

class GroupSelector extends StatelessWidget {
  final List<GroupStudentsResponseModel> groups;
  final GroupStudentsResponseModel? selectedGroup;
  final Function(GroupStudentsResponseModel) onGroupSelected;

  const GroupSelector({
    super.key,
    required this.groups,
    required this.selectedGroup,
    required this.onGroupSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final leftMargin = screenWidth * 0.05;
    final rightMargin = screenWidth * 0.03;

    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    if (groups.length == 1) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: isSmallScreen ? 0 : 2,
        ),
        height: isSmallScreen ? 36 : 48,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0099E9),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedGroup?.title ??
                      groups.first.title ??
                      'Выберите группу',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Убираем иконку стрелки, чтобы визуально было понятно, что список не раскрывается
              const SizedBox(width: 24),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: isSmallScreen ? 0 : 2,
      ),
      height: isSmallScreen ? 36 : 48,
      child: PopupMenuButton<GroupStudentsResponseModel>(
        offset: const Offset(0, 0),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
          minWidth: screenWidth - leftMargin - rightMargin,
          maxWidth: screenWidth - leftMargin - rightMargin,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0099E9),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedGroup?.title ?? 'Выберите группу',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: isSmallScreen ? 20 : 24,
              ),
            ],
          ),
        ),
        onSelected: (group) {
          if (selectedGroup?.id != group.id) {
            onGroupSelected(group);
          }
        },
        itemBuilder: (context) {
          return groups.map((group) {
            final isSelected = selectedGroup?.id == group.id;

            return PopupMenuItem<GroupStudentsResponseModel>(
              value: group,
              padding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withAlpha(51),
                      width: groups.indexOf(group) != groups.length - 1
                          ? 0.5
                          : 0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        group.title ?? 'Группа ${group.id}',
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF0099E9)
                              : Colors.grey.shade800,
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: const Color(0xFF0099E9),
                        size: 18,
                      ),
                  ],
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
