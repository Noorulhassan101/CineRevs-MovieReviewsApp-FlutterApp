import 'package:zenthra/shared/utils/adaptive_colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RatingSelector extends StatelessWidget {
  final double currentRating;
  final Function(double) onRatingSelected;

  const RatingSelector({
    super.key,
    required this.currentRating,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOUR RATING',
          style: TextStyle(
            color: AppColors.textSecondary,
            letterSpacing: 2,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              final rating = index + 1.0;
              final isSelected = rating <= currentRating;
              
              return GestureDetector(
                onTap: () => onRatingSelected(rating),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  width: 36,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryAccent : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryAccent : context.adaptiveWhite10,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isSelected ? Colors.black : context.adaptiveWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
