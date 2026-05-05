import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/review_model.dart';

part 'reviews_repository.g.dart';

class ReviewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReview(Review review) async {
    await _firestore
        .collection('reviews')
        .doc(review.id)
        .set(review.toJson());
  }

  Stream<List<Review>> getReviewsForMedia(String mediaId) {
    return _firestore
        .collection('reviews')
        .where('mediaId', isEqualTo: mediaId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromJson(doc.data()))
            .toList());
  }

  Future<double> getAverageRating(String mediaId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('mediaId', isEqualTo: mediaId)
        .get();
    
    if (snapshot.docs.isEmpty) return 0.0;
    
    final total = snapshot.docs
        .map((doc) => Review.fromJson(doc.data()).rating)
        .reduce((a, b) => a + b);
    
    return total / snapshot.docs.length;
  }

  /// Stream of reviews authored by a specific user (for Profile screen).
  Stream<List<Review>> getReviewsByUser(String userId) {
    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromJson(doc.data()))
            .toList());
  }

  /// Stream of all reviews globally (for Community Feed).
  Stream<List<Review>> watchAllReviews({int limit = 50}) {
    return _firestore
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromJson(doc.data()))
            .toList());
  }
}

@riverpod
ReviewsRepository reviewsRepository(ReviewsRepositoryRef ref) {
  return ReviewsRepository();
}

@riverpod
Stream<List<Review>> mediaReviews(MediaReviewsRef ref, String mediaId) {
  return ref.watch(reviewsRepositoryProvider).getReviewsForMedia(mediaId);
}

@riverpod
Future<double> averageRating(AverageRatingRef ref, String mediaId) {
  return ref.watch(reviewsRepositoryProvider).getAverageRating(mediaId);
}

// ── Additional Manual Providers (no build_runner needed) ──────────────

/// Reviews written by the currently logged-in user.
final userReviewsProvider = StreamProvider<List<Review>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return Stream.value([]);
  return ref.watch(reviewsRepositoryProvider).getReviewsByUser(user.uid);
});

/// Global feed of all reviews across the platform.
final globalReviewsProvider = StreamProvider<List<Review>>((ref) {
  return ref.watch(reviewsRepositoryProvider).watchAllReviews();
});
