// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trendingMoviesHash() => r'95a90869ed75668ad92a01c239383b6e7a832710';

/// See also [trendingMovies].
@ProviderFor(trendingMovies)
final trendingMoviesProvider =
    AutoDisposeFutureProvider<List<MediaItem>>.internal(
  trendingMovies,
  name: r'trendingMoviesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trendingMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TrendingMoviesRef = AutoDisposeFutureProviderRef<List<MediaItem>>;
String _$popularAnimeHash() => r'2372600c84b8daaa638b066ef59169c149c0ac61';

/// See also [popularAnime].
@ProviderFor(popularAnime)
final popularAnimeProvider =
    AutoDisposeFutureProvider<List<MediaItem>>.internal(
  popularAnime,
  name: r'popularAnimeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$popularAnimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PopularAnimeRef = AutoDisposeFutureProviderRef<List<MediaItem>>;
String _$searchResultsHash() => r'0031df64c94a7d618006e6bcb6b0465598f22a19';

/// See also [searchResults].
@ProviderFor(searchResults)
final searchResultsProvider =
    AutoDisposeFutureProvider<List<MediaItem>>.internal(
  searchResults,
  name: r'searchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchResultsRef = AutoDisposeFutureProviderRef<List<MediaItem>>;
String _$searchQueryHash() => r'286abcff51dc844febe02639bb2e883ccab22cfd';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
