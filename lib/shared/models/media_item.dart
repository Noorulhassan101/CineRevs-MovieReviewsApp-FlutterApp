import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';
part 'media_item.g.dart';

enum MediaType { movie, tv, anime }

@freezed
class MediaItem with _$MediaItem {
  const factory MediaItem({
    required String id,
    required String title,
    required String overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    required double voteAverage,
    required MediaType type,
    // For Anime specific fields if needed
    int? episodes,
    String? status,
  }) = _MediaItem;

  factory MediaItem.fromJson(Map<String, dynamic> json) => _$MediaItemFromJson(json);
}
