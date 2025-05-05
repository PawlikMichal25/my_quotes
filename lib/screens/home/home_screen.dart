import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/my_quotes_icons.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:my_quotes/screens/about/about_screen.dart';
import 'package:my_quotes/screens/add_quote/add_quote_screen.dart';
import 'package:my_quotes/screens/search/search_screen.dart';
import 'package:my_quotes/tabs/authors/authors_tab_bloc.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab.dart';

import 'package:my_quotes/tabs/authors/authors_tab.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _index = 0;
  late TabController _tabController;

  late QuotesTabBloc _quotesTabBloc;
  late AuthorsTabBloc _authorsTabBloc;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _tabController.animation!.addListener(_onTabChanged);

    final quotesTabBlocProvider = sl.get<QuotesTabBlocProvider>();
    _quotesTabBloc = quotesTabBlocProvider.get();
    _authorsTabBloc = sl.get<AuthorsTabBloc>();

    _refreshTabs();
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
        title: Text(_index == 0 ? Strings.quotes : Strings.authors),
        actions: [_buildSearchAction(), _buildMoreAction()],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
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
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => _onFABClicked(),
            )
          : null,
    );
  }

  Widget _buildSearchAction() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => SearchScreen()),
        );
        _refreshTabs();
      },
    );
  }

  Widget _buildMoreAction() {
    return PopupMenuButton<MoreAction>(
      onSelected: _onMoreActionSelected,
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<MoreAction>(
            value: MoreAction.about,
            child: Text(Strings.about),
          ),
        ];
      },
    );
  }

  Future<void> _onMoreActionSelected(MoreAction action) async {
    switch (action) {
      case MoreAction.about:
        await Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => AboutScreen()),
        );
    }
  }

  Future<void> _onFABClicked() async {
    await Navigator.push(
      context,
      MaterialPageRoute<Quote>(builder: (context) => AddQuoteScreen()),
    );
    _refreshTabs();
  }

  void _onTabChanged() {
    final aniValue = _tabController.animation!.value;
    if (aniValue > 0.5 && _index != 1) {
      setState(() {
        _index = 1;
      });
    } else if (aniValue <= 0.5 && _index != 0) {
      setState(() {
        _index = 0;
      });
    }
  }

  void _refreshTabs() {
    _quotesTabBloc.loadQuotes();
    _authorsTabBloc.loadAuthors();
  }
}

enum MoreAction {
  about,
}
