import 'package:my_quotes/domain/get_quotes_use_case.dart';
import 'package:my_quotes/domain/search_use_case.dart';

import 'quotes_tab_bloc.dart';

class QuotesTabBlocProvider {
  final GetQuotesUseCase _getQuotesUseCase;
  final SearchUseCase _searchUseCase;

  QuotesTabBlocProvider(this._getQuotesUseCase, this._searchUseCase);

  QuotesTabBloc get({int authorKey}) {
    return QuotesTabBloc(_getQuotesUseCase, _searchUseCase, authorKey);
  }
}
