import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/tabs/quotes/quotes_tab.dart';

class AuthorScreen extends StatefulWidget {
  final Author author;

  AuthorScreen({this.author});

  @override
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.author.firstName} ${widget.author.lastName}"),
      ),
      body: QuotesTab(
        author: widget.author,
      ),
    );
  }
}
