import 'package:zenthra/features/favorites/domain/favorite_item.dart';
import 'package:zenthra/shared/models/media_item.dart';

extension FavoriteMapper on FavoriteItem {
  /// Converts FavoriteItem to MediaItem for UI presentation.
  MediaItem toMediaItem() {
    return MediaItem(
      id: mediaId,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      type: _stringToMediaType(type),
    );
  }
}

/// Converts string type to MediaType enum
MediaType _stringToMediaType(String type) {
  return switch (type.toLowerCase()) {
    'movie' => MediaType.movie,
    'tv' => MediaType.tv,
    'anime' => MediaType.anime,
    _ => MediaType.movie, // Default to movie
  };
}
