import 'package:zenthra/shared/utils/adaptive_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/media_item.dart';
import '../../../auth/data/auth_repository.dart';
import '../../data/reviews_repository.dart';
import '../../data/community_repository.dart';
import '../../domain/review_model.dart';
import 'rating_selector.dart';

class ReviewSheet extends ConsumerStatefulWidget {
  final MediaItem mediaItem;

  const ReviewSheet({super.key, required this.mediaItem});

  @override
  ConsumerState<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<ReviewSheet> {
  double _rating = 5.0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;
  String? _selectedCommunityId;
  String? _selectedCommunityName;

  @override
  void initState() {
    super.initState();
    // Default to global if needed, but we'll try to pick the first joined one
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_commentController.text.trim().isEmpty) return;

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    final review = Review(
      id: const Uuid().v4(),
      userId: user.uid,
      userName: user.email?.split('@')[0] ?? 'Anonymous',
      mediaId: widget.mediaItem.id,
      mediaType: widget.mediaItem.type.name,
      rating: _rating,
      comment: _commentController.text.trim(),
      createdAt: DateTime.now(),
      communityId: _selectedCommunityId ?? 'global',
      communityName: _selectedCommunityName ?? 'Global Feed',
    );

    try {
      await ref.read(reviewsRepositoryProvider).addReview(review);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post review: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REVIEW ${widget.mediaItem.title.toUpperCase()}',
              style: const TextStyle(
                color: AppColors.primaryAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            RatingSelector(
              currentRating: _rating,
              onRatingSelected: (val) => setState(() => _rating = val),
            ),
            const SizedBox(height: 24),
            Text(
              'SELECT COMMUNITY',
              style: TextStyle(color: context.adaptiveWhite54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            ref.watch(userCommunitiesProvider).when(
              data: (communities) {
                final items = [
                  const DropdownMenuItem(value: 'global', child: Text('GLOBAL FEED')),
                  ...communities.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name.toUpperCase()))),
                ];
                
                // Ensure selection is valid
                if (_selectedCommunityId == null || !items.any((i) => i.value == _selectedCommunityId)) {
                  _selectedCommunityId = 'global';
                  _selectedCommunityName = 'Global Feed';
                }

                return DropdownButtonFormField<String>(
                  value: _selectedCommunityId,
                  dropdownColor: AppColors.surface,
                  style: TextStyle(color: context.adaptiveWhite, fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: items,
                  onChanged: (val) {
                    setState(() {
                      _selectedCommunityId = val!;
                      if (val == 'global') {
                        _selectedCommunityName = 'Global Feed';
                      } else {
                        _selectedCommunityName = communities.firstWhere((c) => c.id == val).name;
                      }
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error loading communities: $e'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _commentController,
              maxLines: 4,
              style: TextStyle(color: context.adaptiveWhite),
              decoration: InputDecoration(
                hintText: 'WRITE YOUR THOUGHTS...',
                hintStyle: TextStyle(color: context.adaptiveWhite24, fontSize: 12),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text('POST REVIEW', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
