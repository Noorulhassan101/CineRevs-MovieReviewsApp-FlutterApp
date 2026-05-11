// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_details_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$watchCommunityHash() => r'44e29e35929408e0eba5d7f5c34421e8c20d5614';

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

/// See also [watchCommunity].
@ProviderFor(watchCommunity)
const watchCommunityProvider = WatchCommunityFamily();

/// See also [watchCommunity].
class WatchCommunityFamily extends Family<AsyncValue<Community>> {
  /// See also [watchCommunity].
  const WatchCommunityFamily();

  /// See also [watchCommunity].
  WatchCommunityProvider call(
    String communityId,
  ) {
    return WatchCommunityProvider(
      communityId,
    );
  }

  @override
  WatchCommunityProvider getProviderOverride(
    covariant WatchCommunityProvider provider,
  ) {
    return call(
      provider.communityId,
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
  String? get name => r'watchCommunityProvider';
}

/// See also [watchCommunity].
class WatchCommunityProvider extends AutoDisposeStreamProvider<Community> {
  /// See also [watchCommunity].
  WatchCommunityProvider(
    String communityId,
  ) : this._internal(
          (ref) => watchCommunity(
            ref as WatchCommunityRef,
            communityId,
          ),
          from: watchCommunityProvider,
          name: r'watchCommunityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchCommunityHash,
          dependencies: WatchCommunityFamily._dependencies,
          allTransitiveDependencies:
              WatchCommunityFamily._allTransitiveDependencies,
          communityId: communityId,
        );

  WatchCommunityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.communityId,
  }) : super.internal();

  final String communityId;

  @override
  Override overrideWith(
    Stream<Community> Function(WatchCommunityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchCommunityProvider._internal(
        (ref) => create(ref as WatchCommunityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        communityId: communityId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Community> createElement() {
    return _WatchCommunityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchCommunityProvider && other.communityId == communityId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, communityId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchCommunityRef on AutoDisposeStreamProviderRef<Community> {
  /// The parameter `communityId` of this provider.
  String get communityId;
}

class _WatchCommunityProviderElement
    extends AutoDisposeStreamProviderElement<Community> with WatchCommunityRef {
  _WatchCommunityProviderElement(super.provider);

  @override
  String get communityId => (origin as WatchCommunityProvider).communityId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
