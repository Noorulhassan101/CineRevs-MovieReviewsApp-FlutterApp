// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_section.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communityMessagesHash() => r'370d5134b1b494f51347ab2e7aab119290462f7e';

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

/// See also [communityMessages].
@ProviderFor(communityMessages)
const communityMessagesProvider = CommunityMessagesFamily();

/// See also [communityMessages].
class CommunityMessagesFamily extends Family<AsyncValue<List<ChatMessage>>> {
  /// See also [communityMessages].
  const CommunityMessagesFamily();

  /// See also [communityMessages].
  CommunityMessagesProvider call(
    String communityId,
  ) {
    return CommunityMessagesProvider(
      communityId,
    );
  }

  @override
  CommunityMessagesProvider getProviderOverride(
    covariant CommunityMessagesProvider provider,
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
  String? get name => r'communityMessagesProvider';
}

/// See also [communityMessages].
class CommunityMessagesProvider
    extends AutoDisposeStreamProvider<List<ChatMessage>> {
  /// See also [communityMessages].
  CommunityMessagesProvider(
    String communityId,
  ) : this._internal(
          (ref) => communityMessages(
            ref as CommunityMessagesRef,
            communityId,
          ),
          from: communityMessagesProvider,
          name: r'communityMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$communityMessagesHash,
          dependencies: CommunityMessagesFamily._dependencies,
          allTransitiveDependencies:
              CommunityMessagesFamily._allTransitiveDependencies,
          communityId: communityId,
        );

  CommunityMessagesProvider._internal(
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
    Stream<List<ChatMessage>> Function(CommunityMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommunityMessagesProvider._internal(
        (ref) => create(ref as CommunityMessagesRef),
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
  AutoDisposeStreamProviderElement<List<ChatMessage>> createElement() {
    return _CommunityMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommunityMessagesProvider &&
        other.communityId == communityId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, communityId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommunityMessagesRef on AutoDisposeStreamProviderRef<List<ChatMessage>> {
  /// The parameter `communityId` of this provider.
  String get communityId;
}

class _CommunityMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<ChatMessage>>
    with CommunityMessagesRef {
  _CommunityMessagesProviderElement(super.provider);

  @override
  String get communityId => (origin as CommunityMessagesProvider).communityId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
