// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewsRepositoryHash() => r'5e58555c9d27b3a65648d20dd4dcbca9dafe6a62';

/// See also [reviewsRepository].
@ProviderFor(reviewsRepository)
final reviewsRepositoryProvider =
    AutoDisposeProvider<ReviewsRepository>.internal(
  reviewsRepository,
  name: r'reviewsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReviewsRepositoryRef = AutoDisposeProviderRef<ReviewsRepository>;
String _$mediaReviewsHash() => r'76a8f1712452986c8243951343b66a4380e28129';

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

/// See also [mediaReviews].
@ProviderFor(mediaReviews)
const mediaReviewsProvider = MediaReviewsFamily();

/// See also [mediaReviews].
class MediaReviewsFamily extends Family<AsyncValue<List<Review>>> {
  /// See also [mediaReviews].
  const MediaReviewsFamily();

  /// See also [mediaReviews].
  MediaReviewsProvider call(
    String mediaId,
  ) {
    return MediaReviewsProvider(
      mediaId,
    );
  }

  @override
  MediaReviewsProvider getProviderOverride(
    covariant MediaReviewsProvider provider,
  ) {
    return call(
      provider.mediaId,
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
  String? get name => r'mediaReviewsProvider';
}

/// See also [mediaReviews].
class MediaReviewsProvider extends AutoDisposeStreamProvider<List<Review>> {
  /// See also [mediaReviews].
  MediaReviewsProvider(
    String mediaId,
  ) : this._internal(
          (ref) => mediaReviews(
            ref as MediaReviewsRef,
            mediaId,
          ),
          from: mediaReviewsProvider,
          name: r'mediaReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mediaReviewsHash,
          dependencies: MediaReviewsFamily._dependencies,
          allTransitiveDependencies:
              MediaReviewsFamily._allTransitiveDependencies,
          mediaId: mediaId,
        );

  MediaReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mediaId,
  }) : super.internal();

  final String mediaId;

  @override
  Override overrideWith(
    Stream<List<Review>> Function(MediaReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MediaReviewsProvider._internal(
        (ref) => create(ref as MediaReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mediaId: mediaId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Review>> createElement() {
    return _MediaReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaReviewsProvider && other.mediaId == mediaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mediaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MediaReviewsRef on AutoDisposeStreamProviderRef<List<Review>> {
  /// The parameter `mediaId` of this provider.
  String get mediaId;
}

class _MediaReviewsProviderElement
    extends AutoDisposeStreamProviderElement<List<Review>>
    with MediaReviewsRef {
  _MediaReviewsProviderElement(super.provider);

  @override
  String get mediaId => (origin as MediaReviewsProvider).mediaId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
