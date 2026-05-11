// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      mediaId: json['mediaId'] as String,
      mediaType: json['mediaType'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      communityId: json['communityId'] as String? ?? 'global',
      communityName: json['communityName'] as String? ?? 'Global',
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'mediaId': instance.mediaId,
      'mediaType': instance.mediaType,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'likesCount': instance.likesCount,
      'likedBy': instance.likedBy,
      'commentsCount': instance.commentsCount,
      'communityId': instance.communityId,
      'communityName': instance.communityName,
    };
