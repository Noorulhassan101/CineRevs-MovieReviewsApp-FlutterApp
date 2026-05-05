import 'package:isar/isar.dart';

part 'discovery_item.g.dart';

@collection
class DiscoveryItem {
  Id? id;

  @Index(unique: true, replace: true)
  late String mediaId;
  
  late String category; // 'trending_movies', 'popular_anime'
  
  late String title;
  late String overview;
  String? posterPath;
  String? backdropPath;
  late String type; 
  late double voteAverage;
  late DateTime cachedAt;
}
