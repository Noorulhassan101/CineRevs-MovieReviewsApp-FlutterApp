import 'package:zenthra/shared/utils/adaptive_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../discovery_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_container.dart';

class RecentSearchesView extends ConsumerWidget {
  const RecentSearchesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Mocking recent searches for now
    final recentSearches = ['INCEPTION', 'JUJUTSU KAISEN', 'THE BEAR']; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'HISTORICAL_LOGS',
            style: TextStyle(color: context.adaptiveWhite24, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 3),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              final query = recentSearches[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => ref.read(searchQueryProvider.notifier).update(query.toLowerCase()),
                  child: GlassContainer(
                    borderRadius: 8,
                    opacity: 0.05,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        query,
                        style: TextStyle(color: context.adaptiveWhite60, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
