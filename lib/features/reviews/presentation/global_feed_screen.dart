import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../reviews/domain/review_model.dart';

class GlobalFeedScreen extends ConsumerWidget {
  const GlobalFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalReviewsAsync = ref.watch(globalReviewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('COMMUNITY FEED'),
        centerTitle: true,
      ),
      body: globalReviewsAsync.when(
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
                  const Text(
                    'NO REVIEWS YET',
                    style: TextStyle(
                      color: Colors.white24,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Be the first to share your thoughts!',
                    style: TextStyle(color: Colors.white12, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _FeedReviewCard(review: review);
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
      ),
    );
  }
}

/// A review card specifically for the global feed, which also shows the
/// media title so users can tap through to the movie's details page.
class _FeedReviewCard extends StatelessWidget {
  final Review review;

  const _FeedReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media type badge + rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User info
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primaryAccent.withOpacity(0.2),
                    child: Text(
                      review.userName.isNotEmpty
                          ? review.userName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    review.userName.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              // Rating pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Review body
          Text(
            review.comment,
            style: const TextStyle(color: Colors.white70, height: 1.4),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Footer: media type chip + timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.primaryAccent.withOpacity(0.2)),
                ),
                child: Text(
                  review.mediaType.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primaryAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                _formatDate(review.createdAt),
                style: const TextStyle(color: Colors.white24, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'JUST NOW';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m AGO';
    if (diff.inHours < 24) return '${diff.inHours}h AGO';
    if (diff.inDays < 7) return '${diff.inDays}d AGO';
    return '${date.day}/${date.month}/${date.year}';
  }
}
