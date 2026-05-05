import '../../../shared/models/media_item.dart';

class WatchlistItem {
  final String id;
  final String userId;
  final String mediaId;
  final String title;
  final String? posterPath;
  final String type;
  final double voteAverage;
  final DateTime addedAt;

  const WatchlistItem({
    required this.id,
    required this.userId,
    required this.mediaId,
    required this.title,
    this.posterPath,
    required this.type,
    required this.voteAverage,
    required this.addedAt,
  });

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      mediaId: json['mediaId'] as String,
      title: json['title'] as String,
      posterPath: json['posterPath'] as String?,
      type: json['type'] as String,
      voteAverage: (json['voteAverage'] as num).toDouble(),
      addedAt: json['addedAt'] is DateTime
          ? json['addedAt'] as DateTime
          : DateTime.fromMillisecondsSinceEpoch(
              (json['addedAt'] as dynamic).millisecondsSinceEpoch as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mediaId': mediaId,
      'title': title,
      'posterPath': posterPath,
      'type': type,
      'voteAverage': voteAverage,
      'addedAt': addedAt,
    };
  }

  // Helper to convert to MediaItem for UI
  MediaItem toMediaItem() {
    return MediaItem(
      id: mediaId,
      title: title,
      overview: '',
      posterPath: posterPath,
      type: MediaType.values.byName(type),
      voteAverage: voteAverage,
    );
  }
}
