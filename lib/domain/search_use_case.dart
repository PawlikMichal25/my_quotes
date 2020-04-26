import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/data/quotes/quotes_database.dart';
import 'package:my_quotes/model/quote.dart';

class SearchUseCase {
  final AuthorsDatabase _authorsDatabase;
  final QuotesDatabase _quotesDatabase;

  List<Quote> _quotesCache;

  SearchUseCase(this._authorsDatabase, this._quotesDatabase);

  Future<List<Quote>> execute(String query, bool revalidateCache) async {
    final results = <Quote>[];
    final quotes = await _getQuotesCache(revalidateCache);
    final words = query.trim().toLowerCase().split(' ');

    for (final quote in quotes) {
      if (_quoteContainsWords(quote, words)) {
        results.add(quote);
      }
    }
    return results;
  }

  Future<List<Quote>> _getQuotesCache(bool revalidateCache) async {
    if (_quotesCache == null || revalidateCache) {
      final authors = await _authorsDatabase.getAllAuthors();
      final quotes = await _quotesDatabase.getAllQuotes(authors);
      _quotesCache = quotes;
    }

    return _quotesCache;
  }

  bool _quoteContainsWords(Quote quote, List<String> words) {
    final content = quote.content.toLowerCase();
    final firstName = quote.author.firstName.toLowerCase();
    final lastName = quote.author.lastName.toLowerCase();
    for (final word in words) {
      if (!(content.contains(word) || firstName.contains(word) || lastName.contains(word))) {
        return false;
      }
    }
    return true;
  }
}
