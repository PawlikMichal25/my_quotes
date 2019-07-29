import 'package:flutter/material.dart';
import 'package:my_quotes/home/quotes_tab.dart';

import 'authors_tab.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('MyQuotes'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.format_quote)),
              Tab(icon: Icon(Icons.people)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            QuotesTab(),
            AuthorsTab(),
          ],
        ),
      ),
    );
  }
}
