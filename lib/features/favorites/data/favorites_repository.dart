import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/favorite_item.dart';
import '../../../shared/models/media_item.dart';

part 'favorites_repository.g.dart';

class FavoritesRepository {
  final Isar _isar;

  FavoritesRepository(this._isar);

  Stream<List<FavoriteItem>> watchFavorites() {
    return _isar.favoriteItems.where().sortByAddedAtDesc().watch(fireImmediately: true);
  }

  Future<void> toggleFavorite(MediaItem media) async {
    final existing = await _isar.favoriteItems.filter().mediaIdEqualTo(media.id).findFirst();
    
    await _isar.writeTxn(() async {
      if (existing != null) {
        await _isar.favoriteItems.delete(existing.id!);
      } else {
        final favorite = FavoriteItem()
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

  Future<bool> isFavorite(String mediaId) async {
    final count = await _isar.favoriteItems.filter().mediaIdEqualTo(mediaId).count();
    return count > 0;
  }
}

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(FavoritesRepositoryRef ref) {
  throw UnimplementedError('Provider was not initialized with an Isar instance');
}

@riverpod
Future<bool> isFavorite(IsFavoriteRef ref, String mediaId) {
  return ref.watch(favoritesRepositoryProvider).isFavorite(mediaId);
}

@riverpod
Stream<List<FavoriteItem>> favoritesList(FavoritesListRef ref) {
  return ref.watch(favoritesRepositoryProvider).watchFavorites();
}
