class ActivityItemData {
  final String title;
  final int points;
  final String iconPath;
  final DateTime? createdAt;

  const ActivityItemData({
    required this.title,
    required this.points,
    required this.iconPath,
    this.createdAt,
  });
}

class AchievementChipData {
  final String label;
  final String iconPath;

  const AchievementChipData({required this.label, required this.iconPath});
}
