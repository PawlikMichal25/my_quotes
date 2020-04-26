import 'package:hive/hive.dart';

part 'author_entity.g.dart';

@HiveType(typeId: 0)
class AuthorEntity extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;
}
