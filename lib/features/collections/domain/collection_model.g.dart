// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollectionImpl _$$CollectionImplFromJson(Map<String, dynamic> json) =>
    _$CollectionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isPublic: json['isPublic'] as bool? ?? true,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CollectionImplToJson(_$CollectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'title': instance.title,
      'description': instance.description,
      'items': instance.items,
      'isPublic': instance.isPublic,
      'likesCount': instance.likesCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
