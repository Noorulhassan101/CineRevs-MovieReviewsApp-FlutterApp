import 'package:zenthra/shared/utils/adaptive_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../discovery_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_container.dart';

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(discoveryFilterProvider);
    final theme = Theme.of(context);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (filter.isApplied)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => ref.read(discoveryFilterProvider.notifier).reset(),
                child: GlassContainer(
                  borderRadius: 12,
                  opacity: 0.2,
                  glowColor: Colors.redAccent,
                  showGlow: true,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.refresh, size: 16, color: Colors.redAccent),
                  ),
                ),
              ),
            ),
          
          _FilterChip(
            label: filter.year ?? 'YEAR',
            isSelected: filter.year != null,
            onPressed: () => _showYearPicker(context, ref),
          ),
          
          const SizedBox(width: 12),
          
          _FilterChip(
            label: filter.minRating != null ? '★ ${filter.minRating}' : 'RATING',
            isSelected: filter.minRating != null,
            onPressed: () => _showRatingPicker(context, ref),
          ),
        ],
      ),
    );
  }

  void _showYearPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 30,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(24),
          children: ['2024', '2023', '2022', '2021', '2020', '2010s', '2000s'].map((year) {
            return ListTile(
              title: Text(year, style: TextStyle(color: context.adaptiveWhite, fontWeight: FontWeight.bold, letterSpacing: 1)),
              onTap: () {
                ref.read(discoveryFilterProvider.notifier).setYear(year);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showRatingPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 30,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(24),
          children: [9.0, 8.0, 7.0, 6.0].map((rating) {
            return ListTile(
              title: Text('★ $rating+', style: TextStyle(color: context.adaptiveWhite, fontWeight: FontWeight.bold, letterSpacing: 1)),
              onTap: () {
                ref.read(discoveryFilterProvider.notifier).setRating(rating);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: GlassContainer(
        borderRadius: 12,
        opacity: isSelected ? 0.3 : 0.05,
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : context.adaptiveWhite10,
          width: 1,
        ),
        showGlow: isSelected,
        glowColor: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isSelected ? theme.colorScheme.primary : context.adaptiveWhite60,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
