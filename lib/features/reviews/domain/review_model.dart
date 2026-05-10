import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String userId,
    required String userName,
    required String mediaId,
    required String mediaType, // 'movie' or 'anime'
    required double rating, // 1.0 to 10.0
    required String comment,
    required DateTime createdAt,
    @Default(0) int likesCount,
    @Default([]) List<String> likedBy,
    @Default(0) int commentsCount,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
