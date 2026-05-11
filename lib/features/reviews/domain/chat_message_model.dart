import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String communityId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String text,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isEdited,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
