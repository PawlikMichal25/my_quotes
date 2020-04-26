import 'package:hive/hive.dart';

part 'quote_entity.g.dart';

@HiveType(typeId: 1)
class QuoteEntity extends HiveObject {
  @HiveField(0)
  int authorKey;

  @HiveField(1)
  String content;
}
