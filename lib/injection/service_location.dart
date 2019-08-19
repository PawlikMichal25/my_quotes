import 'package:get_it/get_it.dart';
import 'package:my_quotes/db/dao.dart';
import 'package:my_quotes/db/app_database.dart';
import 'package:my_quotes/screens/add_author/add_author_bloc.dart';
import 'package:my_quotes/screens/add_quote/add_quote_bloc.dart';
import 'package:my_quotes/screens/edit_author/edit_author_bloc.dart';
import 'package:my_quotes/screens/edit_quote/edit_quote_bloc.dart';
import 'package:my_quotes/tabs/authors/authors_tab_bloc.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc_provider.dart';

GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  await _setupDatabase();
  _setupBlocs();
}

Future<void> _setupDatabase() async {
  final database = AppDatabase();
  sl.registerSingleton<AppDatabase>(database);

  final client = await database.client;
  final dao = Dao(client);
  sl.registerFactory<Dao>(() => dao);
}

void _setupBlocs() {
  sl.registerFactory<AuthorsTabBloc>(() {
    return AuthorsTabBloc(dao: sl.get<Dao>());
  });

  sl.registerFactory<QuotesTabBlocProvider>(() {
    return QuotesTabBlocProvider(dao: sl.get<Dao>());
  });

  sl.registerFactory<AddQuoteBloc>(() {
    return AddQuoteBloc(dao: sl.get<Dao>());
  });

  sl.registerFactory<AddAuthorBloc>(() {
    return AddAuthorBloc(dao: sl.get<Dao>());
  });

  sl.registerFactory<EditQuoteBloc>(() {
    return EditQuoteBloc(dao: sl.get<Dao>());
  });

  sl.registerFactory<EditAuthorBloc>(() {
    return EditAuthorBloc(dao: sl.get<Dao>());
  });
}
