import 'package:flutter/foundation.dart';
import 'package:my_quotes/db/dao.dart';

import 'quotes_tab_bloc.dart';

class QuotesTabBlocProvider {
  final Dao dao;

  QuotesTabBlocProvider({@required this.dao}) : assert(dao != null);

  QuotesTabBloc get({int authorId}) {
    return QuotesTabBloc(
      dao: dao,
      authorId: authorId,
    );
  }
}
