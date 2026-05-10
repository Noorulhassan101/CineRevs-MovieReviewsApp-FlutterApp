import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/review_model.dart';
import '../../domain/comment_model.dart';
import '../../data/reviews_repository.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../profile/data/social_repository.dart';
import '../../../notifications/data/notifications_repository.dart';

class CommentSection extends ConsumerStatefulWidget {
  final Review review;

  const CommentSection({super.key, required this.review});

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(reviewCommentsProvider(widget.review.id));
    final currentUser = ref.watch(authRepositoryProvider).currentUser;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const Text(
            'DISCUSSIONS',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          // Comments List
          Expanded(
            child: commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'NO COMMENTS YET. START THE CONVERSATION!',
                      style: TextStyle(color: Colors.white10, fontSize: 12),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _CommentTile(comment: comment);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: const TextStyle(color: Colors.white24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: currentUser != null ? _postComment : null,
                  icon: const Icon(Icons.send, color: AppColors.primaryAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    // Get display name from profile if available
    final profile = await ref.read(socialRepositoryProvider).watchProfile(user.uid).first;
    final userName = profile?.displayName ?? user.email ?? 'Unknown';

    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.uid,
      userName: userName,
      text: text,
      createdAt: DateTime.now(),
    );

    await ref.read(reviewsRepositoryProvider).addComment(
      reviewId: widget.review.id,
      comment: comment,
      authorId: widget.review.userId,
      notificationsRepo: ref.read(notificationsRepositoryProvider),
    );
    _commentController.clear();
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primaryAccent.withOpacity(0.1),
            child: Text(
              comment.userName.isNotEmpty ? comment.userName[0].toUpperCase() : '?',
              style: const TextStyle(color: AppColors.primaryAccent, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName.toUpperCase(),
                  style: const TextStyle(color: AppColors.primaryAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
