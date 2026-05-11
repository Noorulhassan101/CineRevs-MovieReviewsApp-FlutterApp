import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_repository.dart';
import '../../profile/data/social_repository.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../notifications/domain/notification_model.dart';
import '../domain/review_model.dart';
import '../domain/comment_model.dart';

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
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              if (data['createdAt'] is Timestamp) {
                data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
              }
              return Review.fromJson(data);
            }).toList());
  }

  Future<double> getAverageRating(String mediaId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('mediaId', isEqualTo: mediaId)
        .get();
    
    if (snapshot.docs.isEmpty) return 0.0;
    
    final total = snapshot.docs
        .map((doc) {
          final data = doc.data();
          if (data['createdAt'] is Timestamp) {
            data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
          }
          return Review.fromJson(data).rating;
        })
        .reduce((a, b) => a + b);
    
    return total / snapshot.docs.length;
  }

  Stream<List<Review>> getReviewsByUser(String userId) {
    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              if (data['createdAt'] is Timestamp) {
                data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
              }
              return Review.fromJson(data);
            }).toList());
  }

  Stream<List<Review>> watchAllReviews({int limit = 50}) {
    return _firestore
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              if (data['createdAt'] is Timestamp) {
                data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
              }
              return Review.fromJson(data);
            }).toList());
  }

  Stream<List<Review>> getReviewsByCommunity(String communityId, {int limit = 50}) {
    Query query = _firestore.collection('reviews');
    
    if (communityId != 'global') {
      query = query.where('communityId', isEqualTo: communityId);
    }
    
    return query
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              if (data['createdAt'] is Timestamp) {
                data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
              }
              return Review.fromJson(data);
            }).toList());
  }

  Stream<List<Review>> getReviewsByFollowing(List<String> followingIds, {int limit = 50}) {
    if (followingIds.isEmpty) return Stream.value([]);
    
    return _firestore
        .collection('reviews')
        .where('userId', whereIn: followingIds)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              if (data['createdAt'] is Timestamp) {
                data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
              }
              return Review.fromJson(data);
            }).toList());
  }

  Future<void> toggleLikeReview({
    required String reviewId,
    required String userId,
    required String userName,
    required NotificationsRepository notificationsRepo,
  }) async {
    final docRef = _firestore.collection('reviews').doc(reviewId);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final List<String> likedBy = List<String>.from(data['likedBy'] ?? []);
    final isLiked = likedBy.contains(userId);
    final authorId = data['userId'] as String;

    if (isLiked) {
      await docRef.update({
        'likesCount': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      await docRef.update({
        'likesCount': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });

      if (userId != authorId) {
        final notification = NotificationItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fromUserId: userId,
          fromUserName: userName,
          type: 'like',
          targetId: reviewId,
          createdAt: DateTime.now(),
        );
        await notificationsRepo.addNotification(authorId, notification);
      }
    }
  }

  Future<void> addComment({
    required String reviewId,
    required Comment comment,
    required String authorId,
    required NotificationsRepository notificationsRepo,
  }) async {
    await _firestore
        .collection('reviews')
        .doc(reviewId)
        .collection('comments')
        .doc(comment.id)
        .set(comment.toJson());
    
    await _firestore.collection('reviews').doc(reviewId).update({
      'commentsCount': FieldValue.increment(1),
    });

    if (comment.userId != authorId) {
      final notification = NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromUserId: comment.userId,
        fromUserName: comment.userName,
        type: 'comment',
        targetId: reviewId,
        createdAt: DateTime.now(),
      );
      await notificationsRepo.addNotification(authorId, notification);
    }
  }

  Stream<List<Comment>> watchComments(String reviewId) {
    return _firestore
        .collection('reviews')
        .doc(reviewId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              if (data['createdAt'] is Timestamp) {
                data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
              }
              return Comment.fromJson(data);
            }).toList());
  }

  Stream<List<Review>> getFollowedUserReviewsForMedia(String mediaId, List<String> followingIds) {
    if (followingIds.isEmpty) return Stream.value([]);
    
    return _firestore
        .collection('reviews')
        .where('mediaId', isEqualTo: mediaId)
        .where('userId', whereIn: followingIds)
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

final userReviewsProvider = StreamProvider<List<Review>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return Stream.value([]);
  return ref.watch(reviewsRepositoryProvider).getReviewsByUser(user.uid);
});

final globalReviewsProvider = StreamProvider<List<Review>>((ref) {
  return ref.watch(reviewsRepositoryProvider).watchAllReviews();
});

final communityReviewsProvider = StreamProvider.family<List<Review>, String>((ref, communityId) {
  return ref.watch(reviewsRepositoryProvider).getReviewsByCommunity(communityId);
});

final followingReviewsProvider = StreamProvider<List<Review>>((ref) {
  final followingIdsAsync = ref.watch(followingIdsProvider);
  return followingIdsAsync.when(
    data: (ids) => ref.watch(reviewsRepositoryProvider).getReviewsByFollowing(ids),
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final reviewCommentsProvider = StreamProvider.family<List<Comment>, String>((ref, reviewId) {
  return ref.watch(reviewsRepositoryProvider).watchComments(reviewId);
});

final followedMediaReviewsProvider = StreamProvider.family<List<Review>, String>((ref, mediaId) {
  final followingIdsAsync = ref.watch(followingIdsProvider);
  return followingIdsAsync.when(
    data: (ids) => ref.watch(reviewsRepositoryProvider).getFollowedUserReviewsForMedia(mediaId, ids),
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
