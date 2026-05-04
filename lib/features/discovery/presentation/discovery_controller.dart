import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/discovery_repository.dart';
import '../../../shared/models/media_item.dart';

part 'discovery_controller.g.dart';

@riverpod
Future<List<MediaItem>> trendingMovies(TrendingMoviesRef ref) {
  return ref.watch(discoveryRepositoryProvider).getTrendingMovies();
}

@riverpod
Future<List<MediaItem>> popularAnime(PopularAnimeRef ref) {
  return ref.watch(discoveryRepositoryProvider).getPopularAnime();
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
Future<List<MediaItem>> searchResults(SearchResultsRef ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return Future.value([]);
  
  return ref.watch(discoveryRepositoryProvider).searchMedia(query);
}
