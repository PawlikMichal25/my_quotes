class Tables {
  Tables._();

  static const authorTableName = "author";
  static const authorColumnID = '_id';
  static const authorColumnFirstName = 'first_name';
  static const authorColumnLastName = 'last_name';

  static const quoteTableName = "quote";
  static const quoteColumnId = '_id';
  static const quoteColumnAuthorId = 'author_id';
  static const quoteColumnContent = 'content';
}
