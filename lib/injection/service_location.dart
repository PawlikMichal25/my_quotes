import 'package:get_it/get_it.dart';
import 'package:my_quotes/db/dao.dart';
import 'package:my_quotes/db/app_database.dart';

GetIt sl = GetIt();

void setupServiceLocator() async {
  await _setupDatabase();
}

void _setupDatabase() async {
  final database = AppDatabase();
  sl.registerSingleton<AppDatabase>(database);

  final client = await database.client;
  final dao = Dao(client);
  sl.registerFactory<Dao>(() => dao);
}
