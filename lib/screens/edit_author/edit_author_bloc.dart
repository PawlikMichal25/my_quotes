import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/data/authors/authors_database.dart';
import 'package:my_quotes/domain/delete_author_use_case.dart';
import 'package:my_quotes/model/author.dart';

class EditAuthorBloc extends Bloc {
  final AuthorsDatabase _authorsDatabase;
  final DeleteAuthorUseCase _deleteAuthorUseCase;

  EditAuthorBloc(this._authorsDatabase, this._deleteAuthorUseCase);

  @override
  void dispose() {}

  Future<Author> editAuthor({int authorKey, String firstName, String lastName}) {
    return _authorsDatabase.editAuthor(
      authorKey: authorKey,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<void> deleteAuthor(int authorKey) => _deleteAuthorUseCase.execute(authorKey);
}
