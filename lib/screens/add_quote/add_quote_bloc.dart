import 'package:flutter/foundation.dart';
import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/commons/architecture/resource.dart';
import 'package:my_quotes/db/dao.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:rxdart/rxdart.dart';

class AddQuoteBloc extends Bloc {
  final Dao dao;

  final _authors = BehaviorSubject<Resource<List<Author>>>();

  Stream<Resource<List<Author>>> get authorsStream => _authors.stream;

  AddQuoteBloc({
    @required this.dao,
  }) : assert(dao != null);

  @override
  void dispose() {
    _authors.close();
  }

  Future<void> loadAuthors() async {
    _authors.add(Resource.loading());
    final results = await dao.getAllAuthorsOrdered();
    _authors.add(Resource.success(data: results));
  }

  Future<Quote> addQuote({
    String content,
    Author author,
  }) async {
    final quote = await dao.addQuote(Quote(content: content, author: author));

    return quote;
  }
}
