// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritesRepositoryHash() =>
    r'55123a3c626ab0c9993554a4f3009d08f44b315e';

/// See also [favoritesRepository].
@ProviderFor(favoritesRepository)
final favoritesRepositoryProvider = Provider<FavoritesRepository>.internal(
  favoritesRepository,
  name: r'favoritesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoritesRepositoryRef = ProviderRef<FavoritesRepository>;
String _$isFavoriteHash() => r'8d8014a3beaa776829249dfff0babbbef5463576';

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

/// See also [isFavorite].
@ProviderFor(isFavorite)
const isFavoriteProvider = IsFavoriteFamily();

/// See also [isFavorite].
class IsFavoriteFamily extends Family<AsyncValue<bool>> {
  /// See also [isFavorite].
  const IsFavoriteFamily();

  /// See also [isFavorite].
  IsFavoriteProvider call(
    String mediaId,
  ) {
    return IsFavoriteProvider(
      mediaId,
    );
  }

  @override
  IsFavoriteProvider getProviderOverride(
    covariant IsFavoriteProvider provider,
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
  String? get name => r'isFavoriteProvider';
}

/// See also [isFavorite].
class IsFavoriteProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [isFavorite].
  IsFavoriteProvider(
    String mediaId,
  ) : this._internal(
          (ref) => isFavorite(
            ref as IsFavoriteRef,
            mediaId,
          ),
          from: isFavoriteProvider,
          name: r'isFavoriteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isFavoriteHash,
          dependencies: IsFavoriteFamily._dependencies,
          allTransitiveDependencies:
              IsFavoriteFamily._allTransitiveDependencies,
          mediaId: mediaId,
        );

  IsFavoriteProvider._internal(
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
    FutureOr<bool> Function(IsFavoriteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsFavoriteProvider._internal(
        (ref) => create(ref as IsFavoriteRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsFavoriteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFavoriteProvider && other.mediaId == mediaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mediaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsFavoriteRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `mediaId` of this provider.
  String get mediaId;
}

class _IsFavoriteProviderElement extends AutoDisposeFutureProviderElement<bool>
    with IsFavoriteRef {
  _IsFavoriteProviderElement(super.provider);

  @override
  String get mediaId => (origin as IsFavoriteProvider).mediaId;
}

String _$favoritesListHash() => r'ec944d0008ecaacee12cc6af93375c3360c8623e';

/// See also [favoritesList].
@ProviderFor(favoritesList)
final favoritesListProvider =
    AutoDisposeStreamProvider<List<FavoriteItem>>.internal(
  favoritesList,
  name: r'favoritesListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoritesListRef = AutoDisposeStreamProviderRef<List<FavoriteItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
