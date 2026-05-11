import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/favorite_item.dart';
import '../../../shared/models/media_item.dart';

part 'favorites_repository.g.dart';

String favoriteEntryKey(String userId, String mediaId) => '$userId|$mediaId';

class FavoritesRepository {
  final Isar _isar;

  FavoritesRepository(this._isar);

  Stream<List<FavoriteItem>> watchFavorites(String userId) {
    return _isar.favoriteItems
        .filter()
        .userIdEqualTo(userId)
        .sortByAddedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<void> toggleFavorite(String userId, MediaItem media) async {
    final key = favoriteEntryKey(userId, media.id);
    final existing =
        await _isar.favoriteItems.filter().entryKeyEqualTo(key).findFirst();

    await _isar.writeTxn(() async {
      if (existing != null) {
        await _isar.favoriteItems.delete(existing.id!);
      } else {
        final favorite = FavoriteItem()
          ..entryKey = key
          ..userId = userId
          ..mediaId = media.id
          ..title = media.title
          ..overview = media.overview
          ..posterPath = media.posterPath
          ..backdropPath = media.backdropPath
          ..type = media.type.name
          ..voteAverage = media.voteAverage
          ..addedAt = DateTime.now();
        await _isar.favoriteItems.put(favorite);
      }
    });
  }

  Future<bool> isFavorite(String userId, String mediaId) async {
    final key = favoriteEntryKey(userId, mediaId);
    final count = await _isar.favoriteItems.filter().entryKeyEqualTo(key).count();
    return count > 0;
  }
}

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(FavoritesRepositoryRef ref) {
  throw UnimplementedError('Provider was not initialized with an Isar instance');
}

@riverpod
Future<bool> isFavorite(IsFavoriteRef ref, String mediaId) async {
  // Select on uid so this rebuilds when switching accounts (watching AuthRepository does not).
  final uid = ref.watch(authStateChangesProvider.select((a) => a.valueOrNull?.uid));
  if (uid == null) return false;
  return ref.read(favoritesRepositoryProvider).isFavorite(uid, mediaId);
}

@riverpod
Stream<List<FavoriteItem>> favoritesList(FavoritesListRef ref) {
  final uid = ref.watch(authStateChangesProvider.select((a) => a.valueOrNull?.uid));
  final repo = ref.watch(favoritesRepositoryProvider);
  if (uid == null) return Stream.value(<FavoriteItem>[]);
  return repo.watchFavorites(uid);
}
