import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:my_quotes/screens/home/home_screen.dart';

import 'commons/resources/strings.dart';
import 'commons/resources/styles.dart';

class MyQuotesApp extends StatefulWidget {
  @override
  _MyQuotesAppState createState() => _MyQuotesAppState();
}

class _MyQuotesAppState extends State<MyQuotesApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.my_quotes,
      debugShowCheckedModeBanner: false,
      theme: Styles.theme,
      home: HomeScreen(),
    );
  }
}
