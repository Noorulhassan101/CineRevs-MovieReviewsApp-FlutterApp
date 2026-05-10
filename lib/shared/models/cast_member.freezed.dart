// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cast_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CastMember _$CastMemberFromJson(Map<String, dynamic> json) {
  return _CastMember.fromJson(json);
}

/// @nodoc
mixin _$CastMember {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get character => throw _privateConstructorUsedError;
  String? get profilePath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CastMemberCopyWith<CastMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CastMemberCopyWith<$Res> {
  factory $CastMemberCopyWith(
          CastMember value, $Res Function(CastMember) then) =
      _$CastMemberCopyWithImpl<$Res, CastMember>;
  @useResult
  $Res call({String id, String name, String? character, String? profilePath});
}

/// @nodoc
class _$CastMemberCopyWithImpl<$Res, $Val extends CastMember>
    implements $CastMemberCopyWith<$Res> {
  _$CastMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? character = freezed,
    Object? profilePath = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      character: freezed == character
          ? _value.character
          : character // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePath: freezed == profilePath
          ? _value.profilePath
          : profilePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CastMemberImplCopyWith<$Res>
    implements $CastMemberCopyWith<$Res> {
  factory _$$CastMemberImplCopyWith(
          _$CastMemberImpl value, $Res Function(_$CastMemberImpl) then) =
      __$$CastMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? character, String? profilePath});
}

/// @nodoc
class __$$CastMemberImplCopyWithImpl<$Res>
    extends _$CastMemberCopyWithImpl<$Res, _$CastMemberImpl>
    implements _$$CastMemberImplCopyWith<$Res> {
  __$$CastMemberImplCopyWithImpl(
      _$CastMemberImpl _value, $Res Function(_$CastMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? character = freezed,
    Object? profilePath = freezed,
  }) {
    return _then(_$CastMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      character: freezed == character
          ? _value.character
          : character // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePath: freezed == profilePath
          ? _value.profilePath
          : profilePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CastMemberImpl implements _CastMember {
  const _$CastMemberImpl(
      {required this.id, required this.name, this.character, this.profilePath});

  factory _$CastMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$CastMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? character;
  @override
  final String? profilePath;

  @override
  String toString() {
    return 'CastMember(id: $id, name: $name, character: $character, profilePath: $profilePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CastMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.profilePath, profilePath) ||
                other.profilePath == profilePath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, character, profilePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CastMemberImplCopyWith<_$CastMemberImpl> get copyWith =>
      __$$CastMemberImplCopyWithImpl<_$CastMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CastMemberImplToJson(
      this,
    );
  }
}

abstract class _CastMember implements CastMember {
  const factory _CastMember(
      {required final String id,
      required final String name,
      final String? character,
      final String? profilePath}) = _$CastMemberImpl;

  factory _CastMember.fromJson(Map<String, dynamic> json) =
      _$CastMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get character;
  @override
  String? get profilePath;
  @override
  @JsonKey(ignore: true)
  _$$CastMemberImplCopyWith<_$CastMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
