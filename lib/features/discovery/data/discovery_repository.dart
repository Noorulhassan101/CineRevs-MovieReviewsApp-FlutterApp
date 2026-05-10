import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/models/media_mappers.dart';
import '../../../shared/models/cast_member.dart';
import 'package:isar/isar.dart';
import '../domain/discovery_item.dart';
import '../domain/recent_search.dart';
import '../../../../core/network/isar_provider.dart';

part 'discovery_repository.g.dart';

class DiscoveryRepository {
  final Dio _dio;
  final Isar _isar;

  DiscoveryRepository(this._dio, this._isar);

  Future<List<MediaItem>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.tmdbBaseUrl}/trending/movie/day',
        queryParameters: {
          'api_key': ApiConstants.tmdbApiKey,
          'page': page,
        },
      );
      final List results = response.data['results'];
      return results.map((json) => MediaMappers.fromTmdb(json, MediaType.movie)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<MediaItem>> getPopularAnime({int page = 1}) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.jikanBaseUrl}/top/anime',
        queryParameters: {'page': page},
      );
      final List results = response.data['data'];
      return results.map((json) => MediaMappers.fromJikan(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<MediaItem>> searchMedia(String query, {int page = 1}) async {
    if (query.isEmpty) return [];

    try {
      final futures = [
        _dio.get(
          '${ApiConstants.tmdbBaseUrl}/search/multi',
          queryParameters: {
            'api_key': ApiConstants.tmdbApiKey,
            'query': query,
            'page': page,
          },
        ),
        _dio.get(
          '${ApiConstants.jikanBaseUrl}/anime',
          queryParameters: {
            'q': query,
            'page': page,
          },
        ),
      ];

      final responses = await Future.wait(futures);
      final List<MediaItem> items = [];
      
      final tmdbResults = responses[0].data['results'] as List;
      for (var json in tmdbResults) {
        final mediaType = json['media_type'];
        if (mediaType == 'movie') {
          items.add(MediaMappers.fromTmdb(json, MediaType.movie));
        } else if (mediaType == 'tv') {
          items.add(MediaMappers.fromTmdb(json, MediaType.tv));
        }
      }

      final jikanResults = responses[1].data['data'] as List;
      for (var json in jikanResults) {
        items.add(MediaMappers.fromJikan(json));
      }

      if (page == 1) _saveRecentSearch(query);

      return items;
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.length < 3) return;
    await _isar.writeTxn(() async {
      final search = RecentSearch()
        ..query = query
        ..searchedAt = DateTime.now();
      await _isar.recentSearchs.put(search);
    });
  }

  Future<List<String>> getRecentSearches() async {
    final searches = await _isar.recentSearchs
        .where()
        .sortBySearchedAtDesc()
        .limit(5)
        .findAll();
    return searches.map((s) => s.query).toList();
  }

  Future<List<CastMember>> getMediaCredits(String mediaId, MediaType type) async {
    try {
      if (type == MediaType.anime) {
        final response = await _dio.get('${ApiConstants.jikanBaseUrl}/anime/$mediaId/characters');
        final List results = response.data['data'];
        return results.take(10).map((json) => MediaMappers.castFromJikan(json)).toList();
      } else {
        final endpoint = type == MediaType.movie ? 'movie' : 'tv';
        final response = await _dio.get(
          '${ApiConstants.tmdbBaseUrl}/$endpoint/$mediaId/credits',
          queryParameters: {'api_key': ApiConstants.tmdbApiKey},
        );
        final List results = response.data['cast'];
        return results.take(10).map((json) => MediaMappers.castFromTmdb(json)).toList();
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<MediaItem>> getSimilarMedia(String mediaId, MediaType type) async {
    try {
      if (type == MediaType.anime) {
        final response = await _dio.get('${ApiConstants.jikanBaseUrl}/anime/$mediaId/recommendations');
        final List results = response.data['data'];
        return results.take(6).map((json) => MediaMappers.fromJikan(json['entry'])).toList();
      } else {
        final endpoint = type == MediaType.movie ? 'movie' : 'tv';
        final response = await _dio.get(
          '${ApiConstants.tmdbBaseUrl}/$endpoint/$mediaId/similar',
          queryParameters: {'api_key': ApiConstants.tmdbApiKey},
        );
        final List results = response.data['results'];
        return results.take(6).map((json) => MediaMappers.fromTmdb(json, type)).toList();
      }
    } catch (e) {
      return [];
    }
  }
}

@riverpod
DiscoveryRepository discoveryRepository(DiscoveryRepositoryRef ref) {
  return DiscoveryRepository(
    ref.watch(dioClientProvider),
    ref.watch(isarProvider),
  );
}
