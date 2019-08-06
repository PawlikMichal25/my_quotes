import 'package:my_quotes/model/author.dart';

class EditAuthorResult {
  EditAuthorResult._();

  factory EditAuthorResult.authorChanged(Author author) = AuthorChanged;

  factory EditAuthorResult.authorDeleted() = AuthorDeleted;
}

class AuthorChanged extends EditAuthorResult {
  final Author author;

  AuthorChanged(this.author) : super._();
}

class AuthorDeleted extends EditAuthorResult {
  AuthorDeleted() : super._();
}
