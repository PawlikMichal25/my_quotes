import 'package:flutter/material.dart';

import 'injection/service_location.dart';
import 'my_quotes_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(MyQuotesApp());
}
