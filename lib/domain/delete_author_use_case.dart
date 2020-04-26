import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/data/quotes/quotes_database.dart';

class DeleteAuthorUseCase {
  final AuthorsDatabase _authorsDatabase;
  final QuotesDatabase _quotesDatabase;

  DeleteAuthorUseCase(this._authorsDatabase, this._quotesDatabase);

  Future<void> execute(int authorKey) async {
    await _quotesDatabase.deleteQuotesWithAuthor(authorKey);
    await _authorsDatabase.deleteAuthor(authorKey);
  }
}
