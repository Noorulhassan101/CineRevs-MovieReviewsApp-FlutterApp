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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(10, (index) {
            final rating = index + 1.0;
            final isSelected = rating <= currentRating;
            
            return GestureDetector(
              onTap: () => onRatingSelected(rating),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryAccent : AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryAccent : Colors.white10,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
