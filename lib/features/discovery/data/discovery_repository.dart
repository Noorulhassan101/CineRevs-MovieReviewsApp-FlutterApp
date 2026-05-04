import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/models/media_mappers.dart';

part 'discovery_repository.g.dart';

class DiscoveryRepository {
  final Dio _dio;

  DiscoveryRepository(this._dio);

  Future<List<MediaItem>> getTrendingMovies() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.tmdbBaseUrl}/trending/movie/day',
        queryParameters: {'api_key': ApiConstants.tmdbApiKey},
      );
      final List results = response.data['results'];
      return results.map((json) => MediaMappers.fromTmdb(json, MediaType.movie)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<MediaItem>> getPopularAnime() async {
    try {
      final response = await _dio.get('${ApiConstants.jikanBaseUrl}/top/anime');
      final List results = response.data['data'];
      return results.map((json) => MediaMappers.fromJikan(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<MediaItem>> searchMedia(String query) async {
    if (query.isEmpty) return [];

    try {
      // Search TMDB (Movies and TV) and Jikan (Anime) concurrently
      final futures = [
        _dio.get(
          '${ApiConstants.tmdbBaseUrl}/search/multi',
          queryParameters: {
            'api_key': ApiConstants.tmdbApiKey,
            'query': query,
          },
        ),
        _dio.get(
          '${ApiConstants.jikanBaseUrl}/anime',
          queryParameters: {'q': query},
        ),
      ];

      final responses = await Future.wait(futures);
      
      final List<MediaItem> items = [];
      
      // Parse TMDB Results
      final tmdbResults = responses[0].data['results'] as List;
      for (var json in tmdbResults) {
        final mediaType = json['media_type'];
        if (mediaType == 'movie') {
          items.add(MediaMappers.fromTmdb(json, MediaType.movie));
        } else if (mediaType == 'tv') {
          items.add(MediaMappers.fromTmdb(json, MediaType.tv));
        }
      }

      // Parse Jikan Results
      final jikanResults = responses[1].data['data'] as List;
      for (var json in jikanResults) {
        items.add(MediaMappers.fromJikan(json));
      }

      return items;
    } catch (e) {
      return [];
    }
  }
}

@riverpod
DiscoveryRepository discoveryRepository(DiscoveryRepositoryRef ref) {
  return DiscoveryRepository(ref.watch(dioClientProvider));
}
