import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/chat_message_model.dart';

part 'messaging_repository.g.dart';

class MessagingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send a message to a community chat
  Future<String> sendMessage(
    String communityId,
    String userId,
    String userName,
    String? userPhotoUrl,
    String text,
  ) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    
    await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .doc(messageId)
        .set({
          'id': messageId,
          'communityId': communityId,
          'userId': userId,
          'userName': userName,
          'userPhotoUrl': userPhotoUrl,
          'text': text,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isEdited': false,
        });
    
    return messageId;
  }

  /// Edit an existing message
  Future<void> editMessage(
    String communityId,
    String messageId,
    String newText,
  ) async {
    await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .doc(messageId)
        .update({
          'text': newText,
          'updatedAt': FieldValue.serverTimestamp(),
          'isEdited': true,
        });
  }

  /// Delete a message
  Future<void> deleteMessage(
    String communityId,
    String messageId,
  ) async {
    await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  /// Watch messages from a community (real-time, newest first)
  Stream<List<ChatMessage>> watchCommunityMessages(String communityId) {
    return _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(50) // Load 50 newest messages
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            if (data['createdAt'] is Timestamp) {
              data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
            }
            if (data['updatedAt'] is Timestamp) {
              data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
            }
            return ChatMessage.fromJson(data);
          }).toList();
        });
  }

  /// Get message count for a community (for stats)
  Future<int> getMessageCount(String communityId) async {
    final snapshot = await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}

@riverpod
MessagingRepository messagingRepository(MessagingRepositoryRef ref) {
  return MessagingRepository();
}
