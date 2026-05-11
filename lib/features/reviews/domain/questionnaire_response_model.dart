import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_response_model.freezed.dart';
part 'questionnaire_response_model.g.dart';

@freezed
class QuestionnaireResponse with _$QuestionnaireResponse {
  const factory QuestionnaireResponse({
    required String id,
    required String communityId,
    required String userId,
    required String questionnaireId,
    required Map<String, dynamic> answers, // questionId -> answer (text or selected choice)
    @Default('approved') String status, // 'pending', 'approved', 'rejected'
    required DateTime createdAt,
    required DateTime responseAt,
  }) = _QuestionnaireResponse;

  factory QuestionnaireResponse.fromJson(Map<String, dynamic> json) => _$QuestionnaireResponseFromJson(json);
}
