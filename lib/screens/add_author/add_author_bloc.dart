import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/commons/architecture/either.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/model/author.dart';

class AddAuthorBloc extends Bloc {
  final AuthorsDatabase _authorsDatabase;

  AddAuthorBloc(this._authorsDatabase);

  @override
  void dispose() {}

  Future<Either<String, Author>> addAuthor({
    String firstName,
    String lastName,
  }) async {
    final key = await _authorsDatabase.getKeyOfAuthorWith(
      firstName: firstName,
      lastName: lastName,
    );

    if (key != -1) {
      return Either.left(Strings.this_author_already_exists);
    } else {
      final author = await _authorsDatabase.addAuthor(
        Author(
          firstName: firstName,
          lastName: lastName,
        ),
      );
      return Either.right(author);
    }
  }
}
