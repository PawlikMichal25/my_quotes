import 'package:flutter/material.dart';
import 'db/Database.dart';
import 'package:my_quotes/model/author.dart';

class MyQuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyQuotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyQuotes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text(
                'try',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _try();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _try() async {
    final Database database = Database.instance;
    final dao = await database.getDao();
    final author1 = Author(firstName: "First", lastName: "Second");
    final author2 = Author(firstName: "Third", lastName: "Fourth");

    dao.addAuthor(author1);
    dao.addAuthor(author2);

    final authors = await dao.getAllAuthors();
    print(authors);
  }
}
