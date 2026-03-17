import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/features/raiting/presentation/widgets/rating_background.dart';

class RatingLoadingWidget extends StatelessWidget {
  const RatingLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.skyBlue,
      body: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}

class RatingEmptyWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh;

  const RatingEmptyWidget({
    super.key,
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.skyBlue,
      body: RatingBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.group_off_rounded,
                size: 64,
                color: Colors.white70,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildRefreshButton(onRefresh),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingErrorWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const RatingErrorWidget({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 24),
              _buildRefreshButton(onRefresh),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRefreshButton(VoidCallback onRefresh) {
  return ElevatedButton(
    onPressed: onRefresh,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.achievementDeepBlue,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
    child: const Text('Обновить'),
  );
}
