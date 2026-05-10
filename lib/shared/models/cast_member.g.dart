// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CastMemberImpl _$$CastMemberImplFromJson(Map<String, dynamic> json) =>
    _$CastMemberImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      character: json['character'] as String?,
      profilePath: json['profilePath'] as String?,
    );

Map<String, dynamic> _$$CastMemberImplToJson(_$CastMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'character': instance.character,
      'profilePath': instance.profilePath,
    };
