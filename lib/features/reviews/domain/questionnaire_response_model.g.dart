// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireResponseImpl _$$QuestionnaireResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireResponseImpl(
      id: json['id'] as String,
      communityId: json['communityId'] as String,
      userId: json['userId'] as String,
      questionnaireId: json['questionnaireId'] as String,
      answers: json['answers'] as Map<String, dynamic>,
      status: json['status'] as String? ?? 'approved',
      createdAt: DateTime.parse(json['createdAt'] as String),
      responseAt: DateTime.parse(json['responseAt'] as String),
    );

Map<String, dynamic> _$$QuestionnaireResponseImplToJson(
        _$QuestionnaireResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'communityId': instance.communityId,
      'userId': instance.userId,
      'questionnaireId': instance.questionnaireId,
      'answers': instance.answers,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'responseAt': instance.responseAt.toIso8601String(),
    };
