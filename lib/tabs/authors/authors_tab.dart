import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/resources/my_quotes_icons.dart';
import 'package:my_quotes/commons/resources/styles.dart';
import 'package:my_quotes/commons/utils/presentation_formatter.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/commons/architecture/resource.dart';
import 'package:my_quotes/screens/author/author_screen.dart';

import 'package:my_quotes/tabs/authors/authors_tab_bloc.dart';
import 'package:provider/provider.dart';

class AuthorsTab extends StatefulWidget {
  final Function onDataChanged;

  AuthorsTab({@required this.onDataChanged});

  @override
  _AuthorsTabState createState() => _AuthorsTabState();
}

class _AuthorsTabState extends State<AuthorsTab> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AuthorsTabBloc>(context);
    return StreamBuilder<Resource<List<Author>>>(
        initialData: Resource.loading(),
        stream: bloc.authorsStream,
        builder: (_, AsyncSnapshot<Resource<List<Author>>> snapshot) {
          final resource = snapshot.data;

          switch (resource.status) {
            case Status.LOADING:
              return _buildProgressIndicator();
            case Status.SUCCESS:
              return _buildSuccessBody(resource.data);
            case Status.ERROR:
              return Text(resource.message);
          }
          return Text('Unknown error');
        });
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessBody(List<Author> authors) {
    if (authors.length == 0)
      return _buildEmptyView();
    else
      return _buildAuthorsList(authors);
  }

  Widget _buildEmptyView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          MyQuotesIcons.authors,
          size: 120.0,
          color: Styles.lightGrey,
        ),
        SizedBox(height: Dimens.halfDefaultSpacing),
        Text(
          'No authors',
          style: TextStyle(
            color: Styles.lightGrey,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorsList(List<Author> authors) {
    return Scrollbar(
      child: ListView.separated(
        itemCount: authors.length,
        separatorBuilder: (context, index) => Divider(
          height: 0.0,
          color: Styles.darkGrey,
        ),
        itemBuilder: (BuildContext context, int index) {
          final author = authors[index];

          return _buildAuthorTile(author);
        },
      ),
    );
  }

  Widget _buildAuthorTile(Author author) {
    return Material(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.defaultSpacing),
          child: Text(
            PresentationFormatter.formatAuthor(author),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
        onTap: () => _openAuthorScreen(author),
      ),
    );
  }

  _openAuthorScreen(Author author) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthorScreen(author: author)),
    );
    widget.onDataChanged();
  }
}
