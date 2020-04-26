import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab.dart';

import 'package:my_quotes/tabs/quotes/quotes_tab_bloc.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController;

  QuotesTabBloc _quotesTabBloc;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() => _onSearchQueryChanged(false));

    final _quotesTabBlocProvider = sl.get<QuotesTabBlocProvider>();
    _quotesTabBloc = _quotesTabBlocProvider.get();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quotesTabBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
      ),
      body: Provider<QuotesTabBloc>.value(
        value: _quotesTabBloc,
        child: QuotesTab(
          onDataChanged: () => _onSearchQueryChanged(true),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: Strings.search_hint,
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  void _onSearchQueryChanged(bool revalidateCache) {
    _quotesTabBloc.search(_searchController.text, revalidateCache: revalidateCache);
  }
}
