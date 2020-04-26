import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/data/quotes/quotes_database.dart';
import 'package:my_quotes/model/quote.dart';

class GetQuotesUseCase {
  final AuthorsDatabase _authorsDatabase;
  final QuotesDatabase _quotesDatabase;

  GetQuotesUseCase(this._authorsDatabase, this._quotesDatabase);

  Future<List<Quote>> execute(int authorKey) async {
    final authors = await _authorsDatabase.getAllAuthors();
    if (authorKey == null) {
      return _quotesDatabase.getAllQuotes(authors);
    } else {
      return _quotesDatabase.getQuotesWithAuthorKey(authors, authorKey);
    }
  }
}
