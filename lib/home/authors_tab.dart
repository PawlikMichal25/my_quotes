import 'package:flutter/material.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/utils/resource.dart';
import 'package:my_quotes/utils/styles.dart';

import 'authors_bloc.dart';

class AuthorsTab extends StatefulWidget {
  @override
  _AuthorsTabState createState() => _AuthorsTabState();
}

class _AuthorsTabState extends State<AuthorsTab> {
  AuthorsBloc _authorsBloc;

  @override
  void initState() {
    super.initState();
    _authorsBloc = sl.get<AuthorsBloc>();
    _authorsBloc.loadAuthors();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Resource<List<Author>>>(
        initialData: Resource.loading(),
        stream: _authorsBloc.authorsStream,
        builder: (_, AsyncSnapshot<Resource<List<Author>>> snapshot) {
          final resource = snapshot.data;

          switch (resource.status) {
            case Status.LOADING:
              return _buildProgressIndicator();
            case Status.SUCCESS:
              return _buildAuthorsList(resource.data);
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

  Widget _buildAuthorsList(List<Author> authors) {
    return ListView.separated(
      itemCount: authors.length,
      separatorBuilder: (context, index) => Divider(
        height: 0.0,
        color: Styles.darkGrey,
      ),
      itemBuilder: (BuildContext context, int index) {
        final author = authors[index];

        return _buildAuthorTile(author);
      },
    );
  }

  Widget _buildAuthorTile(Author author) {
    return Material(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "${author.firstName} ${author.lastName}",
            style: TextStyle(color: Colors.black),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
