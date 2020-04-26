import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/screens/edit_author/edit_author_result.dart';
import 'package:my_quotes/screens/edit_author/edit_author_screen.dart';
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
  Author author;
  QuotesTabBloc _quotesTabBloc;

  @override
  void initState() {
    super.initState();

    author = widget.author;

    final _quotesTabBlocProvider = sl.get<QuotesTabBlocProvider>();
    _quotesTabBloc = _quotesTabBlocProvider.get(authorKey: widget.author.key);
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
        title: Text('${author.firstName} ${author.lastName}'),
        actions: [
          PopupMenuButton<_Action>(
            onSelected: _onActionSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<_Action>(
                  value: _Action.edit,
                  child: Text(Strings.edit),
                )
              ];
            },
          ),
        ],
      ),
      body: Provider<QuotesTabBloc>.value(
        value: _quotesTabBloc,
        child: QuotesTab(
          onDataChanged: () {
            _quotesTabBloc.loadQuotes();
          },
        ),
      ),
    );
  }

  void _onActionSelected(_Action action) async {
    switch (action) {
      case _Action.edit:
        _editAuthor();
        break;
    }
  }

  void _editAuthor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<EditAuthorResult>(
        builder: (context) => EditAuthorScreen(author: widget.author, deletingEnabled: true),
      ),
    );

    if (result is AuthorChanged) {
      final newAuthor = result.author;
      setState(() {
        author = newAuthor;
      });
      await _quotesTabBloc.loadQuotes();
    } else if (result is AuthorDeleted) {
      Navigator.pop(context);
    }
  }
}

enum _Action { edit }
