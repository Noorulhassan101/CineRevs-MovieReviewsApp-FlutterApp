import 'package:isar/isar.dart';

part 'recent_search.g.dart';

@collection
class RecentSearch {
  Id? id;

  @Index(unique: true, replace: true)
  late String query;
  
  late DateTime searchedAt;
}
