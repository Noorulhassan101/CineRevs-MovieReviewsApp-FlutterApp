import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../reviews/domain/review_model.dart';
import '../../reviews/presentation/widgets/review_card.dart';

class GlobalFeedScreen extends ConsumerWidget {
  const GlobalFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('COMMUNITY FEED'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: AppColors.primaryAccent,
            labelColor: AppColors.primaryAccent,
            unselectedLabelColor: Colors.white24,
            tabs: [
              Tab(text: 'GLOBAL'),
              Tab(text: 'FOLLOWING'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ReviewListView(provider: globalReviewsProvider),
            _ReviewListView(provider: followingReviewsProvider, emptyMessage: 'FOLLOW OTHERS TO SEE THEIR REVIEWS HERE!'),
          ],
        ),
      ),
    );
  }
}

class _ReviewListView extends ConsumerWidget {
  final StreamProvider<List<Review>> provider;
  final String emptyMessage;

  const _ReviewListView({
    required this.provider,
    this.emptyMessage = 'NO REVIEWS YET',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(provider);

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.forum_outlined,
                  size: 64,
                  color: Colors.white.withOpacity(0.1),
                ),
                const SizedBox(height: 16),
                Text(
                  emptyMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white24,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return ReviewCard(review: reviews[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text('Error: $err', style: const TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
