import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/data/quotes/quotes_database.dart';
import 'package:my_quotes/model/quote.dart';

class DeleteQuoteUseCase {
  final AuthorsDatabase _authorsDatabase;
  final QuotesDatabase _quotesDatabase;

  DeleteQuoteUseCase(this._authorsDatabase, this._quotesDatabase);

  Future<void> execute(Quote quote) async {
    await _quotesDatabase.deleteQuote(quote.key);
    final authors = await _authorsDatabase.getAllAuthors();
    final others = await _quotesDatabase.getQuotesWithAuthorKey(authors, quote.author.key);
    if (others.isEmpty) {
      await _authorsDatabase.deleteAuthor(quote.author.key);
    }
  }
}
