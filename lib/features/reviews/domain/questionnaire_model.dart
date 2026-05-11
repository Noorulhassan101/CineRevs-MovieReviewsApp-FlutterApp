import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_model.freezed.dart';
part 'questionnaire_model.g.dart';

@freezed
class QuestionItem with _$QuestionItem {
  const factory QuestionItem({
    required String questionId,
    required String text,
    required String questionType, // 'text' or 'multiChoice'
    @Default([]) List<String> choices, // Only populated if questionType is 'multiChoice'
  }) = _QuestionItem;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => _$QuestionItemFromJson(json);
}

@freezed
class CommunityQuestionnaire with _$CommunityQuestionnaire {
  const factory CommunityQuestionnaire({
    required String id,
    required String communityId,
    required String ownerId,
    @Default([]) List<QuestionItem> questions, // 1-5 questions
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CommunityQuestionnaire;

  factory CommunityQuestionnaire.fromJson(Map<String, dynamic> json) => _$CommunityQuestionnaireFromJson(json);
}
