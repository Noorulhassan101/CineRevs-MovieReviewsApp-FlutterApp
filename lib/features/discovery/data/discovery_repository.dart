import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/models/media_mappers.dart';
import 'package:isar/isar.dart';
import '../domain/discovery_item.dart';
import '../domain/recent_search.dart';
import '../../../../core/network/isar_provider.dart';

part 'discovery_repository.g.dart';

class DiscoveryRepository {
  final Dio _dio;
  final Isar _isar;

  DiscoveryRepository(this._dio, this._isar);

  Future<List<MediaItem>> getTrendingMovies() async {
    // 1. Check Cache
    final cached = await _isar.discoveryItems
        .filter()
        .categoryEqualTo('trending_movies')
        .findAll();
    
    if (cached.isNotEmpty) {
      // Return cached immediately, then fetch fresh in background if needed
      // (Simplified: returning cached if present, update on next call)
    }

    try {
      final response = await _dio.get(
        '${ApiConstants.tmdbBaseUrl}/trending/movie/day',
        queryParameters: {'api_key': ApiConstants.tmdbApiKey},
      );
      final List results = response.data['results'];
      final items = results.map((json) => MediaMappers.fromTmdb(json, MediaType.movie)).toList();
      
      // 2. Update Cache
      await _isar.writeTxn(() async {
        await _isar.discoveryItems.filter().categoryEqualTo('trending_movies').deleteAll();
        final discoveryItems = items.map((item) => DiscoveryItem()
          ..mediaId = item.id
          ..category = 'trending_movies'
          ..title = item.title
          ..overview = item.overview
          ..posterPath = item.posterPath
          ..backdropPath = item.backdropPath
          ..type = item.type.name
          ..voteAverage = item.voteAverage
          ..cachedAt = DateTime.now()).toList();
        await _isar.discoveryItems.putAll(discoveryItems);
      });
      
      return items;
    } catch (e) {
      // 3. Fallback to cache on error
      return cached.map((c) => MediaItem(
        id: c.mediaId,
        title: c.title,
        overview: c.overview,
        posterPath: c.posterPath,
        backdropPath: c.backdropPath,
        type: MediaType.values.byName(c.type),
        voteAverage: c.voteAverage,
      )).toList();
    }
  }

  Future<List<MediaItem>> getPopularAnime() async {
    final cached = await _isar.discoveryItems
        .filter()
        .categoryEqualTo('popular_anime')
        .findAll();

    try {
      final response = await _dio.get('${ApiConstants.jikanBaseUrl}/top/anime');
      final List results = response.data['data'];
      final items = results.map((json) => MediaMappers.fromJikan(json)).toList();

      await _isar.writeTxn(() async {
        await _isar.discoveryItems.filter().categoryEqualTo('popular_anime').deleteAll();
        final discoveryItems = items.map((item) => DiscoveryItem()
          ..mediaId = item.id
          ..category = 'popular_anime'
          ..title = item.title
          ..overview = item.overview
          ..posterPath = item.posterPath
          ..backdropPath = item.backdropPath
          ..type = item.type.name
          ..voteAverage = item.voteAverage
          ..cachedAt = DateTime.now()).toList();
        await _isar.discoveryItems.putAll(discoveryItems);
      });

      return items;
    } catch (e) {
      return cached.map((c) => MediaItem(
        id: c.mediaId,
        title: c.title,
        overview: c.overview,
        posterPath: c.posterPath,
        backdropPath: c.backdropPath,
        type: MediaType.values.byName(c.type),
        voteAverage: c.voteAverage,
      )).toList();
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

      // Save to recent searches
      _saveRecentSearch(query);

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
}

@riverpod
DiscoveryRepository discoveryRepository(DiscoveryRepositoryRef ref) {
  return DiscoveryRepository(
    ref.watch(dioClientProvider),
    ref.watch(isarProvider),
  );
}
