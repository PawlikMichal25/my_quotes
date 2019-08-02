import 'package:flutter/foundation.dart';
import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/commons/architecture/either.dart';
import 'package:my_quotes/db/dao.dart';
import 'package:my_quotes/model/author.dart';

class AddAuthorBloc extends Bloc {
  final Dao dao;

  AddAuthorBloc({
    @required this.dao,
  }) : assert(dao != null);

  @override
  void dispose() {}

  Future<Either<String, Author>> addAuthor({
    String firstName,
    String lastName,
  }) async {
    final id = await dao.getIdOfAuthorWith(
      firstName: firstName,
      lastName: lastName,
    );

    if (id != -1) {
      return Either.left('This author already exists');
    } else {
      final author = await dao.addAuthor(
        Author(
          firstName: firstName,
          lastName: lastName,
        ),
      );
      return Either.right(author);
    }
  }
}
