import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/review_model.dart';
import '../../data/reviews_repository.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../profile/data/social_repository.dart';
import '../../../notifications/data/notifications_repository.dart';
import 'comment_section.dart';

class ReviewCard extends ConsumerWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final isLiked = user != null && review.likedBy.contains(user.uid);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.push('/profile/${review.userId}'),
                child: Text(
                  review.userName.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryAccent,
                  ),
                ),
              ),
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
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(review.createdAt),
                style: const TextStyle(color: Colors.white24, fontSize: 10),
              ),
              Row(
                children: [
                  // Likes
                  Text(
                    '${review.likesCount}',
                    style: TextStyle(
                      color: isLiked ? Colors.red : Colors.white24,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () async {
                      if (user != null) {
                        final profile = await ref.read(socialRepositoryProvider).watchProfile(user.uid).first;
                        final userName = profile?.displayName ?? user.email ?? 'Unknown';
                        
                        ref.read(reviewsRepositoryProvider).toggleLikeReview(
                          reviewId: review.id,
                          userId: user.uid,
                          userName: userName,
                          notificationsRepo: ref.read(notificationsRepositoryProvider),
                        );
                      }
                    },
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white24,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Comments
                  Text(
                    '${review.commentsCount}',
                    style: const TextStyle(
                      color: Colors.white24,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _showComments(context, ref),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white24,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComments(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentSection(review: review),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
