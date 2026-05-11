import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/community_model.dart';

part 'community_repository.g.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCommunity(Community community) async {
    await _firestore
        .collection('communities')
        .doc(community.id)
        .set(community.toJson());
  }

  Future<void> joinCommunity(String communityId, String userId) async {
    final docRef = _firestore.collection('communities').doc(communityId);
    
    // Use transaction to ensure idempotent join (no duplicates)
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;
      
      final memberIds = List<String>.from(doc.data()?['memberIds'] ?? []);
      
      // Only add if not already a member
      if (!memberIds.contains(userId)) {
        transaction.update(docRef, {
          'memberIds': FieldValue.arrayUnion([userId]),
          'membersCount': FieldValue.increment(1),
        });
      }
    });
  }

  Future<void> leaveCommunity(String communityId, String userId) async {
    final docRef = _firestore.collection('communities').doc(communityId);
    
    // Use transaction to ensure idempotent leave (no negative counts)
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;

      final memberIds = List<String>.from(doc.data()?['memberIds'] ?? []);
      
      // Only remove if actually a member
      if (memberIds.contains(userId)) {
        transaction.update(docRef, {
          'memberIds': FieldValue.arrayRemove([userId]),
          'membersCount': FieldValue.increment(-1),
        });
      }
    });
  }

  Stream<List<Community>> watchAllCommunities() {
    return _firestore
        .collection('communities')
        .orderBy('membersCount', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Community.fromJson(doc.data())).toList());
  }

  Stream<List<Community>> watchUserCommunities(String userId) {
    return _firestore
        .collection('communities')
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Community.fromJson(doc.data())).toList());
  }

  Future<Community?> getCommunity(String id) async {
    final doc = await _firestore.collection('communities').doc(id).get();
    if (!doc.exists) return null;
    return Community.fromJson(doc.data()!);
  }

  Stream<Community> watchCommunity(String id) {
    return _firestore
        .collection('communities')
        .doc(id)
        .snapshots()
        .map((doc) => Community.fromJson(doc.data() ?? {}));
  }
}

@riverpod
CommunityRepository communityRepository(CommunityRepositoryRef ref) {
  return CommunityRepository();
}

final allCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  return ref.watch(communityRepositoryProvider).watchAllCommunities();
});

final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return Stream.value([]);
  return ref.watch(communityRepositoryProvider).watchUserCommunities(user.uid);
});
