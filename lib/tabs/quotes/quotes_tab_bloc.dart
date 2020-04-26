import 'package:my_quotes/domain/get_quotes_use_case.dart';
import 'package:my_quotes/domain/search_use_case.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/commons/architecture/resource.dart';
import 'package:rxdart/rxdart.dart';

class QuotesTabBloc extends Bloc {
  final GetQuotesUseCase _getQuotesUseCase;
  final SearchUseCase _searchUseCase;
  final int authorKey;

  final _quotes = BehaviorSubject<Resource<List<Quote>>>();

  Stream<Resource<List<Quote>>> get quotesStream => _quotes.stream;

  QuotesTabBloc(this._getQuotesUseCase, this._searchUseCase, this.authorKey);

  @override
  void dispose() {
    _quotes.close();
  }

  Future<void> loadQuotes() async {
    _quotes.add(Resource.loading());
    final results = await _getQuotesUseCase.execute(authorKey);
    _quotes.add(Resource.success(data: results));
  }

  Future<void> search(String query, {bool revalidateCache = false}) async {
    _quotes.add(Resource.loading());
    final results = await _searchUseCase.execute(query, revalidateCache);
    _quotes.add(Resource.success(data: results));
  }
}
