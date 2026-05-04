import 'media_item.dart';
import '../../core/constants/api_constants.dart';

class MediaMappers {
  static MediaItem fromTmdb(Map<String, dynamic> json, MediaType type) {
    return MediaItem(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? 'Unknown',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] != null 
          ? '${ApiConstants.tmdbImageBaseUrl}${json['poster_path']}' 
          : null,
      backdropPath: json['backdrop_path'] != null 
          ? '${ApiConstants.tmdbBackdropBaseUrl}${json['backdrop_path']}' 
          : null,
      releaseDate: json['release_date'] ?? json['first_air_date'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      type: type,
    );
  }

  static MediaItem fromJikan(Map<String, dynamic> json) {
    return MediaItem(
      id: json['mal_id'].toString(),
      title: json['title_english'] ?? json['title'] ?? 'Unknown',
      overview: json['synopsis'] ?? '',
      posterPath: json['images']?['jpg']?['large_image_url'],
      backdropPath: json['images']?['jpg']?['large_image_url'], // Jikan doesn't have a separate backdrop usually
      releaseDate: json['aired']?['string'],
      voteAverage: (json['score'] as num?)?.toDouble() ?? 0.0,
      type: MediaType.anime,
      episodes: json['episodes'],
      status: json['status'],
    );
  }
}
