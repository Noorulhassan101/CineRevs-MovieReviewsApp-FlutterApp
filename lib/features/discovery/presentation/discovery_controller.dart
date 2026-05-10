import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/discovery_repository.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/models/cast_member.dart';
import '../domain/filter_state.dart';
import '../../reviews/data/reviews_repository.dart';

part 'discovery_controller.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }
}

@riverpod
class DiscoveryFilter extends _$DiscoveryFilter {
  @override
  FilterState build() => const FilterState();
  
  void setYear(String? year) => state = state.copyWith(year: year, isApplied: true);
  void setRating(double? rating) => state = state.copyWith(minRating: rating, isApplied: true);
  void reset() => state = const FilterState();
}

@riverpod
class SearchResults extends _$SearchResults {
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  Future<List<MediaItem>> build() async {
    final query = ref.watch(searchQueryProvider);
    final filter = ref.watch(discoveryFilterProvider);
    
    if (query.isEmpty && !filter.isApplied) return [];
    
    _currentPage = 1;
    _hasMore = true;
    
    final results = await ref.read(discoveryRepositoryProvider).searchMedia(query, page: _currentPage);
    return _applyFilters(results, filter);
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !_hasMore) return;

    final query = ref.read(searchQueryProvider);
    final filter = ref.read(discoveryFilterProvider);
    
    _currentPage++;
    final nextResults = await ref.read(discoveryRepositoryProvider).searchMedia(query, page: _currentPage);
    
    if (nextResults.isEmpty) {
      _hasMore = false;
      return;
    }

    final filteredNext = _applyFilters(nextResults, filter);
    state = AsyncData([...state.value ?? [], ...filteredNext]);
  }

  List<MediaItem> _applyFilters(List<MediaItem> items, FilterState filter) {
    return items.where((item) {
      if (filter.year != null && !(item.releaseDate?.contains(filter.year!) ?? false)) return false;
      if (filter.minRating != null && item.voteAverage < filter.minRating!) return false;
      return true;
    }).toList();
  }
}

@riverpod
Future<List<MediaItem>> trendingMovies(TrendingMoviesRef ref) {
  return ref.watch(discoveryRepositoryProvider).getTrendingMovies();
}

@riverpod
Future<List<MediaItem>> popularAnime(PopularAnimeRef ref) {
  return ref.watch(discoveryRepositoryProvider).getPopularAnime();
}

@riverpod
Future<List<MediaItem>> forYouRecommendations(ForYouRecommendationsRef ref) async {
  final userReviewsAsync = ref.watch(userReviewsProvider);
  
  return userReviewsAsync.when(
    data: (reviews) async {
      if (reviews.isEmpty) return [];
      
      final trending = await ref.watch(discoveryRepositoryProvider).getTrendingMovies();
      final popularAnime = await ref.watch(discoveryRepositoryProvider).getPopularAnime();
      
      final all = [...trending, ...popularAnime];
      all.shuffle();
      
      return all.take(10).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
Future<List<CastMember>> mediaCredits(MediaCreditsRef ref, String mediaId, String type) {
  final mediaType = type == 'movie' ? MediaType.movie : (type == 'tv' ? MediaType.tv : MediaType.anime);
  return ref.watch(discoveryRepositoryProvider).getMediaCredits(mediaId, mediaType);
}

@riverpod
Future<List<MediaItem>> similarMedia(SimilarMediaRef ref, String mediaId, String type) {
  final mediaType = type == 'movie' ? MediaType.movie : (type == 'tv' ? MediaType.tv : MediaType.anime);
  return ref.watch(discoveryRepositoryProvider).getSimilarMedia(mediaId, mediaType);
}
