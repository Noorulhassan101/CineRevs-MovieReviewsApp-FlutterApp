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
String _$forYouRecommendationsHash() =>
    r'6cad230fdc8f317f1c53063a3aba71773dcf986e';

/// See also [forYouRecommendations].
@ProviderFor(forYouRecommendations)
final forYouRecommendationsProvider =
    AutoDisposeFutureProvider<List<MediaItem>>.internal(
  forYouRecommendations,
  name: r'forYouRecommendationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forYouRecommendationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ForYouRecommendationsRef
    = AutoDisposeFutureProviderRef<List<MediaItem>>;
String _$mediaCreditsHash() => r'f37ccafffb99364dc72859ec3ef4928200b92489';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [mediaCredits].
@ProviderFor(mediaCredits)
const mediaCreditsProvider = MediaCreditsFamily();

/// See also [mediaCredits].
class MediaCreditsFamily extends Family<AsyncValue<List<CastMember>>> {
  /// See also [mediaCredits].
  const MediaCreditsFamily();

  /// See also [mediaCredits].
  MediaCreditsProvider call(
    String mediaId,
    String type,
  ) {
    return MediaCreditsProvider(
      mediaId,
      type,
    );
  }

  @override
  MediaCreditsProvider getProviderOverride(
    covariant MediaCreditsProvider provider,
  ) {
    return call(
      provider.mediaId,
      provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mediaCreditsProvider';
}

/// See also [mediaCredits].
class MediaCreditsProvider extends AutoDisposeFutureProvider<List<CastMember>> {
  /// See also [mediaCredits].
  MediaCreditsProvider(
    String mediaId,
    String type,
  ) : this._internal(
          (ref) => mediaCredits(
            ref as MediaCreditsRef,
            mediaId,
            type,
          ),
          from: mediaCreditsProvider,
          name: r'mediaCreditsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mediaCreditsHash,
          dependencies: MediaCreditsFamily._dependencies,
          allTransitiveDependencies:
              MediaCreditsFamily._allTransitiveDependencies,
          mediaId: mediaId,
          type: type,
        );

  MediaCreditsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mediaId,
    required this.type,
  }) : super.internal();

  final String mediaId;
  final String type;

  @override
  Override overrideWith(
    FutureOr<List<CastMember>> Function(MediaCreditsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MediaCreditsProvider._internal(
        (ref) => create(ref as MediaCreditsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mediaId: mediaId,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CastMember>> createElement() {
    return _MediaCreditsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaCreditsProvider &&
        other.mediaId == mediaId &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mediaId.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MediaCreditsRef on AutoDisposeFutureProviderRef<List<CastMember>> {
  /// The parameter `mediaId` of this provider.
  String get mediaId;

  /// The parameter `type` of this provider.
  String get type;
}

class _MediaCreditsProviderElement
    extends AutoDisposeFutureProviderElement<List<CastMember>>
    with MediaCreditsRef {
  _MediaCreditsProviderElement(super.provider);

  @override
  String get mediaId => (origin as MediaCreditsProvider).mediaId;
  @override
  String get type => (origin as MediaCreditsProvider).type;
}

String _$similarMediaHash() => r'bb70e59a4d7980f605be46e37f5f39e771a708bc';

/// See also [similarMedia].
@ProviderFor(similarMedia)
const similarMediaProvider = SimilarMediaFamily();

/// See also [similarMedia].
class SimilarMediaFamily extends Family<AsyncValue<List<MediaItem>>> {
  /// See also [similarMedia].
  const SimilarMediaFamily();

  /// See also [similarMedia].
  SimilarMediaProvider call(
    String mediaId,
    String type,
  ) {
    return SimilarMediaProvider(
      mediaId,
      type,
    );
  }

  @override
  SimilarMediaProvider getProviderOverride(
    covariant SimilarMediaProvider provider,
  ) {
    return call(
      provider.mediaId,
      provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'similarMediaProvider';
}

/// See also [similarMedia].
class SimilarMediaProvider extends AutoDisposeFutureProvider<List<MediaItem>> {
  /// See also [similarMedia].
  SimilarMediaProvider(
    String mediaId,
    String type,
  ) : this._internal(
          (ref) => similarMedia(
            ref as SimilarMediaRef,
            mediaId,
            type,
          ),
          from: similarMediaProvider,
          name: r'similarMediaProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$similarMediaHash,
          dependencies: SimilarMediaFamily._dependencies,
          allTransitiveDependencies:
              SimilarMediaFamily._allTransitiveDependencies,
          mediaId: mediaId,
          type: type,
        );

  SimilarMediaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mediaId,
    required this.type,
  }) : super.internal();

  final String mediaId;
  final String type;

  @override
  Override overrideWith(
    FutureOr<List<MediaItem>> Function(SimilarMediaRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SimilarMediaProvider._internal(
        (ref) => create(ref as SimilarMediaRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mediaId: mediaId,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MediaItem>> createElement() {
    return _SimilarMediaProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimilarMediaProvider &&
        other.mediaId == mediaId &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mediaId.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SimilarMediaRef on AutoDisposeFutureProviderRef<List<MediaItem>> {
  /// The parameter `mediaId` of this provider.
  String get mediaId;

  /// The parameter `type` of this provider.
  String get type;
}

class _SimilarMediaProviderElement
    extends AutoDisposeFutureProviderElement<List<MediaItem>>
    with SimilarMediaRef {
  _SimilarMediaProviderElement(super.provider);

  @override
  String get mediaId => (origin as SimilarMediaProvider).mediaId;
  @override
  String get type => (origin as SimilarMediaProvider).type;
}

String _$searchQueryHash() => r'446383cb599327bea368f8da496260b05a5f9bec';

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
String _$discoveryFilterHash() => r'2b42301743d9a0f65625889c062be1e6e8364c76';

/// See also [DiscoveryFilter].
@ProviderFor(DiscoveryFilter)
final discoveryFilterProvider =
    AutoDisposeNotifierProvider<DiscoveryFilter, FilterState>.internal(
  DiscoveryFilter.new,
  name: r'discoveryFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$discoveryFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DiscoveryFilter = AutoDisposeNotifier<FilterState>;
String _$searchResultsHash() => r'e761de8620c8aaf6e7edd5b0bd8bba20c949bcd5';

/// See also [SearchResults].
@ProviderFor(SearchResults)
final searchResultsProvider =
    AutoDisposeAsyncNotifierProvider<SearchResults, List<MediaItem>>.internal(
  SearchResults.new,
  name: r'searchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchResults = AutoDisposeAsyncNotifier<List<MediaItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
