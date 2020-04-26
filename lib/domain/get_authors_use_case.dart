import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/model/author.dart';

class GetAuthorsUseCase {
  final AuthorsDatabase _authorsDatabase;

  GetAuthorsUseCase(this._authorsDatabase);

  Future<List<Author>> execute() async {
    return _authorsDatabase.getAllAuthors();
  }
}
