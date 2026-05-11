import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/watchlist_item.dart';
import '../../../shared/models/media_item.dart';

class WatchlistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<WatchlistItem>> watchWatchlist(String userId) {
    return _firestore
        .collection('watchlist')
        .where('userId', isEqualTo: userId)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WatchlistItem.fromJson(doc.data()))
            .toList());
  }

  Future<void> toggleWatchlist(String userId, MediaItem media) async {
    final docRef = _firestore.collection('watchlist').doc('${userId}_${media.id}');
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      final item = WatchlistItem(
        id: '${userId}_${media.id}',
        userId: userId,
        mediaId: media.id,
        title: media.title,
        posterPath: media.posterPath,
        type: media.type.name,
        voteAverage: media.voteAverage,
        addedAt: DateTime.now(),
      );
      await docRef.set(item.toJson());
    }
  }

  Stream<bool> isInWatchlist(String userId, String mediaId) {
    return _firestore
        .collection('watchlist')
        .doc('${userId}_$mediaId')
        .snapshots()
        .map((doc) => doc.exists);
  }
}

// ── Manual Riverpod Providers ──────────────────────────────────────────

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});

final userWatchlistProvider = StreamProvider<List<WatchlistItem>>((ref) {
  final uid = ref.watch(authStateChangesProvider.select((a) => a.valueOrNull?.uid));
  if (uid == null) return Stream.value([]);
  return ref.watch(watchlistRepositoryProvider).watchWatchlist(uid);
});

final isInWatchlistProvider = StreamProvider.family<bool, String>((ref, mediaId) {
  final uid = ref.watch(authStateChangesProvider.select((a) => a.valueOrNull?.uid));
  if (uid == null) return Stream.value(false);
  return ref.watch(watchlistRepositoryProvider).isInWatchlist(uid, mediaId);
});
