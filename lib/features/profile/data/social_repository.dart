import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/user_profile.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../notifications/domain/notification_model.dart';

part 'social_repository.g.dart';

class SocialRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> followUser({
    required String currentUserId,
    required String currentUserName,
    required String targetUserId,
    required NotificationsRepository notificationsRepo,
  }) async {
    if (currentUserId == targetUserId) return;
    
    final docId = '${currentUserId}_$targetUserId';
    await _firestore.collection('follows').doc(docId).set({
      'followerId': currentUserId,
      'followedId': targetUserId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('users').doc(currentUserId).set({
      'followingCount': FieldValue.increment(1),
    }, SetOptions(merge: true));

    await _firestore.collection('users').doc(targetUserId).set({
      'followersCount': FieldValue.increment(1),
    }, SetOptions(merge: true));

    // Notify target user
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromUserId: currentUserId,
      fromUserName: currentUserName,
      type: 'follow',
      createdAt: DateTime.now(),
    );
    await notificationsRepo.addNotification(targetUserId, notification);
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final docId = '${currentUserId}_$targetUserId';
    await _firestore.collection('follows').doc(docId).delete();

    await _firestore.collection('users').doc(currentUserId).set({
      'followingCount': FieldValue.increment(-1),
    }, SetOptions(merge: true));

    await _firestore.collection('users').doc(targetUserId).set({
      'followersCount': FieldValue.increment(-1),
    }, SetOptions(merge: true));
  }

  Stream<bool> isFollowing(String currentUserId, String targetUserId) {
    final docId = '${currentUserId}_$targetUserId';
    return _firestore
        .collection('follows')
        .doc(docId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Stream<List<String>> getFollowingIds(String userId) {
    return _firestore
        .collection('follows')
        .where('followerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data()['followedId'] as String)
            .toList());
  }

  Stream<int> getFollowersCount(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['followersCount'] as int? ?? 0);
  }

  Stream<int> getFollowingCount(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['followingCount'] as int? ?? 0);
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .set(profile.toJson(), SetOptions(merge: true));
  }

  Stream<UserProfile?> watchProfile(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;
      return UserProfile.fromJson(snapshot.data()!);
    });
  }
}

@riverpod
SocialRepository socialRepository(SocialRepositoryRef ref) {
  return SocialRepository();
}

final isFollowingProvider = StreamProvider.family<bool, String>((ref, targetUserId) {
  final authRepo = ref.watch(authRepositoryProvider);
  final user = authRepo.currentUser;
  if (user == null) return Stream.value(false);
  
  return ref.watch(socialRepositoryProvider).isFollowing(user.uid, targetUserId);
});

final followingIdsProvider = StreamProvider<List<String>>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final user = authRepo.currentUser;
  if (user == null) return Stream.value([]);
  
  return ref.watch(socialRepositoryProvider).getFollowingIds(user.uid);
});

final followersCountProvider = StreamProvider.family<int, String>((ref, userId) {
  return ref.watch(socialRepositoryProvider).getFollowersCount(userId);
});

final followingCountProvider = StreamProvider.family<int, String>((ref, userId) {
  return ref.watch(socialRepositoryProvider).getFollowingCount(userId);
});

final userProfileProvider = StreamProvider.family<UserProfile?, String>((ref, userId) {
  return ref.watch(socialRepositoryProvider).watchProfile(userId);
});

final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return Stream.value(null);
  return ref.watch(socialRepositoryProvider).watchProfile(user.uid);
});
