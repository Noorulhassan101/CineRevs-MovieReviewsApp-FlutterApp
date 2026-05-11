import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/collection_model.dart';
import '../../../shared/models/media_item.dart';
import '../../auth/data/auth_repository.dart';

part 'collections_repository.g.dart';

class CollectionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCollection(Collection collection) async {
    await _firestore
        .collection('collections')
        .doc(collection.id)
        .set(collection.toJson());
  }

  Future<void> addItemToCollection(String collectionId, MediaItem item) async {
    await _firestore.collection('collections').doc(collectionId).update({
      'items': FieldValue.arrayUnion([item.toJson()]),
    });
  }

  Future<void> removeItemFromCollection(String collectionId, MediaItem item) async {
    await _firestore.collection('collections').doc(collectionId).update({
      'items': FieldValue.arrayRemove([item.toJson()]),
    });
  }

  Stream<List<Collection>> watchUserCollections(String userId) {
    return _firestore
        .collection('collections')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              if (data['createdAt'] is Timestamp) {
                data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
              }
              return Collection.fromJson(data);
            }).toList());
  }

  Stream<List<Collection>> watchPublicCollections() {
    return _firestore
        .collection('collections')
        .where('isPublic', isEqualTo: true)
        .orderBy('likesCount', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              if (data['createdAt'] is Timestamp) {
                data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
              }
              return Collection.fromJson(data);
            }).toList());
  }

  Future<void> toggleLikeCollection(String collectionId, String userId) async {
    final docRef = _firestore.collection('collections').doc(collectionId);
    // similar to review likes
  }

  Future<Collection?> getCollection(String id) async {
    final doc = await _firestore.collection('collections').doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    return Collection.fromJson(data);
  }

  Stream<Collection?> watchCollection(String id) {
    return _firestore
        .collection('collections')
        .doc(id)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          final data = doc.data()!;
          if (data['createdAt'] is Timestamp) {
            data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
          }
          return Collection.fromJson(data);
        });
  }
}

@riverpod
CollectionsRepository collectionsRepository(CollectionsRepositoryRef ref) {
  return CollectionsRepository();
}

final userCollectionsProvider = StreamProvider<List<Collection>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return Stream.value([]);
  return ref.watch(collectionsRepositoryProvider).watchUserCollections(user.uid);
});

final publicCollectionsProvider = StreamProvider<List<Collection>>((ref) {
  return ref.watch(collectionsRepositoryProvider).watchPublicCollections();
});
