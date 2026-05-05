import 'package:isar/isar.dart';

part 'favorite_item.g.dart';

@collection
class FavoriteItem {
  Id? id;

  @Index(unique: true, replace: true)
  late String mediaId;
  
  late String title;
  late String overview;
  String? posterPath;
  String? backdropPath;
  late String type; 
  late double voteAverage;
  late DateTime addedAt;
}
