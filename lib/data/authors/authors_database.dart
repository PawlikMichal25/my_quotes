import 'package:hive/hive.dart';
import 'package:my_quotes/data/authors/author_entity.dart';
import 'package:my_quotes/data/boxes.dart';
import 'package:my_quotes/model/author.dart';

class AuthorsDatabase {
  Future<List<Author>> getAllAuthors() async {
    final box = await Hive.openBox<AuthorEntity>(Boxes.authors);
    final entities = box.toMap();

    return entities.keys.map((dynamic key) {
      final entity = entities[key];
      return Author(
        key: key as int,
        firstName: entity.firstName,
        lastName: entity.lastName,
      );
    }).toList();
  }

  Future<List<Author>> getAllAuthorsOrdered() async {
    final authors = await getAllAuthors();
    authors.sort((first, second) {
      final firstName = first.firstName.compareTo(second.firstName);
      if (firstName != 0) return firstName;

      final lastName = first.lastName.compareTo(second.lastName);
      return lastName;
    });
    return authors;
  }

  Future<Author> addAuthor(Author author) async {
    final box = await Hive.openBox<AuthorEntity>(Boxes.authors);
    final entity = AuthorEntity()
      ..firstName = author.firstName
      ..lastName = author.lastName;
    final key = await box.add(entity);
    return Author(
      key: key,
      firstName: entity.firstName,
      lastName: entity.lastName,
    );
  }

  Future<int> getKeyOfAuthorWith({String firstName, String lastName}) async {
    final authors = await getAllAuthors();
    final author = authors.firstWhere(
      (author) => author.firstName == firstName && author.lastName == lastName,
      orElse: () => null,
    );

    return author?.key ?? -1;
  }

  Future<Author> editAuthor({int authorKey, String firstName, String lastName}) async {
    final entity = AuthorEntity()
      ..firstName = firstName
      ..lastName = lastName;

    final box = await Hive.openBox<AuthorEntity>(Boxes.authors);
    await box.put(authorKey, entity);

    return Author(
      key: authorKey,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<void> deleteAuthor(int authorKey) async {
    final box = await Hive.openBox<AuthorEntity>(Boxes.authors);
    await box.delete(authorKey);
  }
}
