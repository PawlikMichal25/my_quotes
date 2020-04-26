import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_quotes/data/authors/author_entity.dart';
import 'package:my_quotes/data/quotes/quote_entity.dart';
import 'package:path_provider/path_provider.dart';

import 'injection/service_location.dart';
import 'my_quotes_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupHive();
  await setupServiceLocator();
  runApp(MyQuotesApp());
}

void _setupHive() async {
  final dbDirectory = await getApplicationDocumentsDirectory();
  Hive.init(dbDirectory.path);
  Hive.registerAdapter(AuthorEntityAdapter());
  Hive.registerAdapter(QuoteEntityAdapter());
}
