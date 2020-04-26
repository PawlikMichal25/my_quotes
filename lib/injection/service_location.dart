import 'package:get_it/get_it.dart';
import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/data/quotes/quotes_database.dart';
import 'package:my_quotes/domain/delete_author_use_case.dart';
import 'package:my_quotes/domain/delete_quote_use_case.dart';
import 'package:my_quotes/domain/get_authors_use_case.dart';
import 'package:my_quotes/domain/get_quotes_use_case.dart';
import 'package:my_quotes/domain/search_use_case.dart';
import 'package:my_quotes/screens/add_author/add_author_bloc.dart';
import 'package:my_quotes/screens/add_quote/add_quote_bloc.dart';
import 'package:my_quotes/screens/edit_author/edit_author_bloc.dart';
import 'package:my_quotes/screens/edit_quote/edit_quote_bloc.dart';
import 'package:my_quotes/tabs/authors/authors_tab_bloc.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc_provider.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  _setupData();
  _setupDomain();
  _setupBlocs();
}

void _setupData() {
  sl.registerSingleton(AuthorsDatabase());
  sl.registerSingleton(QuotesDatabase());
}

void _setupDomain() {
  sl.registerFactory(() => DeleteAuthorUseCase(sl.get<AuthorsDatabase>(), sl.get<QuotesDatabase>()));
  sl.registerFactory(() => DeleteQuoteUseCase(sl.get<AuthorsDatabase>(), sl.get<QuotesDatabase>()));
  sl.registerFactory(() => GetAuthorsUseCase(sl.get<AuthorsDatabase>()));
  sl.registerFactory(() => GetQuotesUseCase(sl.get<AuthorsDatabase>(), sl.get<QuotesDatabase>()));
  sl.registerFactory(() => SearchUseCase(sl.get<AuthorsDatabase>(), sl.get<QuotesDatabase>()));
}

void _setupBlocs() {
  sl.registerFactory(() => AuthorsTabBloc(sl.get<GetAuthorsUseCase>()));
  sl.registerFactory(() => QuotesTabBlocProvider(sl.get<GetQuotesUseCase>(), sl.get<SearchUseCase>()));
  sl.registerFactory(() => AddQuoteBloc(sl.get<AuthorsDatabase>(), sl.get<QuotesDatabase>()));
  sl.registerFactory(() => AddAuthorBloc(sl.get<AuthorsDatabase>()));
  sl.registerFactory(() => EditQuoteBloc(sl.get<QuotesDatabase>(), sl.get<DeleteQuoteUseCase>()));
  sl.registerFactory(() => EditAuthorBloc(sl.get<AuthorsDatabase>(), sl.get<DeleteAuthorUseCase>()));
}
