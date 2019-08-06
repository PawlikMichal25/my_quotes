import 'package:flutter/foundation.dart';
import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/commons/architecture/either.dart';
import 'package:my_quotes/db/dao.dart';
import 'package:my_quotes/model/author.dart';

class EditAuthorBloc extends Bloc {
  final Dao dao;

  EditAuthorBloc({
    @required this.dao,
  }) : assert(dao != null);

  @override
  void dispose() {}

  Future<Either<String, Author>> editAuthor({
    int authorId,
    String firstName,
    String lastName,
  }) async {
    final author = await dao.editAuthor(
      authorId: authorId,
      firstName: firstName,
      lastName: lastName,
    );

    if (author == null) {
      return Either.left('Failed to edit the author');
    } else {
      return Either.right(author);
    }
  }

  Future<void> deleteAuthor({int authorId}) async {
    await dao.deleteAuthor(authorId: authorId);
  }
}
