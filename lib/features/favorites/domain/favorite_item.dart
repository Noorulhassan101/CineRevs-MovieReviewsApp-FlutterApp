import 'package:isar/isar.dart';

part 'favorite_item.g.dart';

@collection
class FavoriteItem {
  Id? id;

  /// Stable per-account row id: `$userId|$mediaId`
  @Index(unique: true, replace: true)
  late String entryKey;

  late String userId;

  @Index()
  late String mediaId;

  late String title;
  late String overview;
  String? posterPath;
  String? backdropPath;
  late String type; 
  late double voteAverage;
  late DateTime addedAt;
}
