import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/my_quotes_icons.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/screens/add_quote/add_quote_screen.dart';
import 'package:my_quotes/tabs/authors/authors_tab_bloc.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab.dart';

import 'package:my_quotes/tabs/authors/authors_tab.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;
  TabController _tabController;

  QuotesTabBloc _quotesTabBloc;
  AuthorsTabBloc _authorsTabBloc;

  @override
  void initState() {
    super.initState();

    final _quotesTabBlocProvider = sl.get<QuotesTabBlocProvider>();
    _quotesTabBloc = _quotesTabBlocProvider.get();
    _authorsTabBloc = sl.get<AuthorsTabBloc>();

    _refreshTabs();

    _tabController = TabController(vsync: this, length: 2);
    _tabController.animation.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _quotesTabBloc.dispose();
    _authorsTabBloc.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(index == 0 ? 'Quotes' : 'Authors'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(MyQuotesIcons.quotes)),
            Tab(icon: Icon(MyQuotesIcons.authors)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Provider<QuotesTabBloc>.value(
            value: _quotesTabBloc,
            child: QuotesTab(
              onDataChanged: _refreshTabs,
            ),
          ),
          Provider<AuthorsTabBloc>.value(
            value: _authorsTabBloc,
            child: AuthorsTab(
              onDataChanged: _refreshTabs,
            ),
          ),
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _onFABClicked(),
            )
          : null,
    );
  }

  void _onTabChanged() {
    final aniValue = _tabController.animation.value;
    if (aniValue > 0.5 && index != 1) {
      setState(() {
        index = 1;
      });
    } else if (aniValue <= 0.5 && index != 0) {
      setState(() {
        index = 0;
      });
    }
  }

  void _onFABClicked() async {
    final quote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddQuoteScreen()),
    );
    if (quote != null) {
      _refreshTabs();
    }
  }

  void _refreshTabs() {
    _quotesTabBloc.loadQuotes();
    _authorsTabBloc.loadAuthors();
  }
}
