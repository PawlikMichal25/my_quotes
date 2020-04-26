import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/commons/architecture/resource.dart';
import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/data/quotes/quotes_database.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:rxdart/rxdart.dart';

class AddQuoteBloc extends Bloc {
  final AuthorsDatabase _authorsDatabase;
  final QuotesDatabase _quotesDatabase;

  final _authors = BehaviorSubject<Resource<List<Author>>>();

  Stream<Resource<List<Author>>> get authorsStream => _authors.stream;

  AddQuoteBloc(this._authorsDatabase, this._quotesDatabase);

  @override
  void dispose() {
    _authors.close();
  }

  Future<void> loadAuthors() async {
    _authors.add(Resource.loading());
    final results = await _authorsDatabase.getAllAuthorsOrdered();
    _authors.add(Resource.success(data: results));
  }

  Future<Quote> addQuote({String content, Author author}) {
    return _quotesDatabase.addQuote(Quote(content: content, author: author));
  }
}
