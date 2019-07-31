import 'package:flutter/foundation.dart';
import 'package:my_quotes/db/dao.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:my_quotes/commons/bloc.dart';
import 'package:my_quotes/commons/resource.dart';
import 'package:rxdart/rxdart.dart';

class QuotesTabBloc extends Bloc {
  final Dao dao;
  final int authorId;

  final _quotes = BehaviorSubject<Resource<List<Quote>>>();

  Stream<Resource<List<Quote>>> get quotesStream => _quotes.stream;

  QuotesTabBloc({
    @required this.dao,
    this.authorId,
  }) : assert(dao != null);

  @override
  void dispose() {
    _quotes.close();
  }

  Future<void> loadQuotes() async {
    _quotes.add(Resource.loading());
    final results = await dao.getQuotes(authorId);
    _quotes.add(Resource.success(data: results));
  }
}
