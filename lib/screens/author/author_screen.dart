import 'package:flutter/material.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab_bloc_provider.dart';
import 'package:provider/provider.dart';

class AuthorScreen extends StatefulWidget {
  final Author author;

  AuthorScreen({this.author});

  @override
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  QuotesTabBloc _quotesTabBloc;

  @override
  void initState() {
    super.initState();

    final _quotesTabBlocProvider = sl.get<QuotesTabBlocProvider>();
    _quotesTabBloc = _quotesTabBlocProvider.get(authorId: widget.author.id);
    _quotesTabBloc.loadQuotes();
  }

  @override
  void dispose() {
    _quotesTabBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.author.firstName} ${widget.author.lastName}"),
      ),
      body: Provider<QuotesTabBloc>.value(
        value: _quotesTabBloc,
        child: QuotesTab(),
      ),
    );
  }
}
