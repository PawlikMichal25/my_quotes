import 'package:hive/hive.dart';
import 'package:my_quotes/data/boxes.dart';
import 'package:my_quotes/data/quotes/quote_entity.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';

class QuotesDatabase {
  Future<List<Quote>> getAllQuotes(List<Author> authors) async {
    final box = await Hive.openBox<QuoteEntity>(Boxes.quotes);
    final entities = box.toMap();

    return entities.keys.map((dynamic key) {
      final entity = entities[key];
      return Quote(
        key: key as int,
        author: authors.firstWhere((author) => author.key == entity.authorKey),
        content: entity.content,
      );
    }).toList();
  }

  Future<List<Quote>> getQuotesWithAuthorKey(List<Author> authors, int authorKey) async {
    final quotes = await getAllQuotes(authors);
    return quotes.where((quote) => quote.author.key == authorKey).toList();
  }

  Future<Quote> addQuote(Quote quote) async {
    final box = await Hive.openBox<QuoteEntity>(Boxes.quotes);
    final entity = QuoteEntity()
      ..authorKey = quote.author.key
      ..content = quote.content;
    final key = await box.add(entity);
    return Quote(
      key: key,
      author: quote.author,
      content: quote.content,
    );
  }

  Future<Quote> editQuote(Quote quote, String newContent) async {
    final entity = QuoteEntity()
      ..authorKey = quote.author.key
      ..content = newContent;

    final box = await Hive.openBox<QuoteEntity>(Boxes.quotes);
    await box.put(quote.key, entity);

    return Quote(
      key: quote.key,
      author: quote.author,
      content: newContent,
    );
  }

  Future<void> deleteQuote(int quoteKey) async {
    final box = await Hive.openBox<QuoteEntity>(Boxes.quotes);
    await box.delete(quoteKey);
  }

  Future<void> deleteQuotesWithAuthor(int authorKey) async {
    final box = await Hive.openBox<QuoteEntity>(Boxes.quotes);
    final quotes = box.toMap();
    final futures = <Future>[];
    for (final entity in quotes.entries) {
      if (entity.value.authorKey == authorKey) {
        futures.add(box.delete(entity.key));
      }
    }
    await Future.wait<void>(futures);
  }
}
