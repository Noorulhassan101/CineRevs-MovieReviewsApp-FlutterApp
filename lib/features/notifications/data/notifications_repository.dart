import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/notification_model.dart';
import '../../auth/data/auth_repository.dart';

part 'notifications_repository.g.dart';

class NotificationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotification(String toUserId, NotificationItem notification) async {
    // Avoid notifying yourself
    if (toUserId == notification.fromUserId) return;

    await _firestore
        .collection('users')
        .doc(toUserId)
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toJson());
  }

  Stream<List<NotificationItem>> watchNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationItem.fromJson(doc.data()))
            .toList());
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final snapshots = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();
    
    for (var doc in snapshots.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}

@riverpod
NotificationsRepository notificationsRepository(NotificationsRepositoryRef ref) {
  return NotificationsRepository();
}

final userNotificationsProvider = StreamProvider<List<NotificationItem>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return Stream.value([]);
  return ref.watch(notificationsRepositoryProvider).watchNotifications(user.uid);
});

final unreadNotificationsCountProvider = StreamProvider<int>((ref) {
  return ref.watch(userNotificationsProvider.stream).map(
    (list) => list.where((n) => !n.isRead).length,
  );
});
