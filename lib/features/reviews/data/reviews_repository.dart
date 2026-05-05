import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
}

@riverpod
ReviewsRepository reviewsRepository(ReviewsRepositoryRef ref) {
  return ReviewsRepository();
}

@riverpod
Stream<List<Review>> mediaReviews(MediaReviewsRef ref, String mediaId) {
  return ref.watch(reviewsRepositoryProvider).getReviewsForMedia(mediaId);
}
