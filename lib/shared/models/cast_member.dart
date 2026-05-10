import 'package:freezed_annotation/freezed_annotation.dart';

part 'cast_member.freezed.dart';
part 'cast_member.g.dart';

@freezed
class CastMember with _$CastMember {
  const factory CastMember({
    required String id,
    required String name,
    String? character,
    String? profilePath,
  }) = _CastMember;

  factory CastMember.fromJson(Map<String, dynamic> json) => _$CastMemberFromJson(json);
}
