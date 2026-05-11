// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionItemImpl _$$QuestionItemImplFromJson(Map<String, dynamic> json) =>
    _$QuestionItemImpl(
      questionId: json['questionId'] as String,
      text: json['text'] as String,
      questionType: json['questionType'] as String,
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$QuestionItemImplToJson(_$QuestionItemImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'text': instance.text,
      'questionType': instance.questionType,
      'choices': instance.choices,
    };

_$CommunityQuestionnaireImpl _$$CommunityQuestionnaireImplFromJson(
        Map<String, dynamic> json) =>
    _$CommunityQuestionnaireImpl(
      id: json['id'] as String,
      communityId: json['communityId'] as String,
      ownerId: json['ownerId'] as String,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CommunityQuestionnaireImplToJson(
        _$CommunityQuestionnaireImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'communityId': instance.communityId,
      'ownerId': instance.ownerId,
      'questions': instance.questions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
