import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../shared/models/media_item.dart';

part 'collection_model.freezed.dart';
part 'collection_model.g.dart';

@freezed
class Collection with _$Collection {
  const factory Collection({
    required String id,
    required String userId,
    required String userName,
    required String title,
    String? description,
    @Default([]) List<MediaItem> items,
    @Default(true) bool isPublic,
    @Default(0) int likesCount,
    required DateTime createdAt,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);
}
