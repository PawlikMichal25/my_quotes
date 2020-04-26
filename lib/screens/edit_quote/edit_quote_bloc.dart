import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/data/quotes/quotes_database.dart';
import 'package:my_quotes/domain/delete_quote_use_case.dart';
import 'package:my_quotes/model/quote.dart';

class EditQuoteBloc extends Bloc {
  final QuotesDatabase _quotesDatabase;
  final DeleteQuoteUseCase _deleteQuoteUseCase;

  EditQuoteBloc(this._quotesDatabase, this._deleteQuoteUseCase);

  @override
  void dispose() {}

  Future<Quote> editQuote(Quote quote, String newContent) => _quotesDatabase.editQuote(quote, newContent);

  Future<void> deleteQuote(Quote quote) => _deleteQuoteUseCase.execute(quote);
}
