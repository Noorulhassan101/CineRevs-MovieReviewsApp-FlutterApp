import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_model.freezed.dart';
part 'community_model.g.dart';

@freezed
class Community with _$Community {
  const factory Community({
    required String id,
    required String ownerId,
    required String name,
    required String description,
    String? iconUrl,
    @Default([]) List<String> memberIds,
    @Default(0) int membersCount,
    required DateTime createdAt,
    @Default('general') String category, // Action, Sci-Fi, etc
  }) = _Community;

  factory Community.fromJson(Map<String, dynamic> json) => _$CommunityFromJson(json);
}
