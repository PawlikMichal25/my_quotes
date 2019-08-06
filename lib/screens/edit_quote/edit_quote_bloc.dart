import 'package:flutter/foundation.dart';
import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/commons/architecture/either.dart';
import 'package:my_quotes/db/dao.dart';
import 'package:my_quotes/model/quote.dart';

class EditQuoteBloc extends Bloc {
  final Dao dao;

  EditQuoteBloc({
    @required this.dao,
  }) : assert(dao != null);

  @override
  void dispose() {}

  Future<Either<String, Quote>> editQuote({
    Quote quote,
    String newContent,
  }) async {
    final newQuote = await dao.editQuote(quote: quote, newContent: newContent);

    if (newQuote == null) {
      return Either.left('Failed to edit the quote');
    } else {
      return Either.right(newQuote);
    }
  }

  Future<void> deleteQuote({Quote quote}) async {
    await dao.deleteQuote(quoteId: quote.id);
    final others = await dao.getQuotesWithAuthorId(authorId: quote.author.id);
    if (others.length == 0) {
      await dao.deleteAuthor(authorId: quote.author.id);
    }
  }
}
