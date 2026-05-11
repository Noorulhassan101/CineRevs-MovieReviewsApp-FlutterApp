import 'package:zenthra/shared/utils/adaptive_colors.dart';
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

class ReviewCard extends ConsumerStatefulWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});

  @override
  ConsumerState<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends ConsumerState<ReviewCard> {
  late bool _isLiked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked = false; // Will be set in build
    _likesCount = widget.review.likesCount;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    _isLiked = user != null && widget.review.likedBy.contains(user.uid);
    _likesCount = widget.review.likesCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.adaptiveWhite.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.push('/profile/${widget.review.userId}'),
                child: Text(
                  widget.review.userName.toUpperCase(),
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
                      widget.review.rating.toStringAsFixed(1),
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
          if (widget.review.communityName != 'Global')
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'IN ${widget.review.communityName.toUpperCase()}',
                style: const TextStyle(color: AppColors.secondaryAccent, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            widget.review.comment,
            style: TextStyle(color: context.adaptiveWhite70, height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(widget.review.createdAt),
                style: TextStyle(color: context.adaptiveWhite70, height: 1.4),
              ),
              Row(
                children: [
                  // Likes
                  Text(
                    '$_likesCount',
                    style: TextStyle(
                      color: _isLiked ? Colors.red : context.adaptiveWhite24,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () async {
                      if (user != null) {
                        // Optimistic Update
                        setState(() {
                          if (_isLiked) {
                            _likesCount--;
                          } else {
                            _likesCount++;
                          }
                          _isLiked = !_isLiked;
                        });

                        final profile = await ref.read(socialRepositoryProvider).watchProfile(user.uid).first;
                        final userName = profile?.displayName ?? user.email ?? 'Unknown';
                        
                        await ref.read(reviewsRepositoryProvider).toggleLikeReview(
                          reviewId: widget.review.id,
                          userId: user.uid,
                          userName: userName,
                          notificationsRepo: ref.read(notificationsRepositoryProvider),
                        );
                      }
                    },
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : context.adaptiveWhite24,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Comments
                  Text(
                    '${widget.review.commentsCount}',
                    style: TextStyle(color: context.adaptiveWhite70, height: 1.4),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _showComments(context, ref),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: context.adaptiveWhite24,
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
      builder: (context) => CommentSection(review: widget.review),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
