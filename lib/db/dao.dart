import 'package:my_quotes/db/tables.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';

class Dao {
  final Database db;

  Dao(this.db);

  Future<Author> addAuthor(Author author) async {
    Map<String, String> row = {
      Tables.authorColumnFirstName: author.firstName,
      Tables.authorColumnLastName: author.lastName
    };

    final id = await db.insert(Tables.authorTableName, row);
    return Author(
      id: id,
      firstName: author.firstName,
      lastName: author.lastName,
    );
  }

  Future<Quote> addQuote(Quote quote) async {
    Map<String, dynamic> row = <String, dynamic>{
      Tables.quoteColumnAuthorId: quote.author.id,
      Tables.quoteColumnContent: quote.content
    };

    final id = await db.insert(Tables.quoteTableName, row);
    return Quote(
      id: id,
      author: quote.author,
      content: quote.content,
    );
  }

  Future<List<Quote>> getQuotes(int authorId) async {
    if (authorId == null) {
      return getAllQuotes();
    } else {
      return getQuotesWithAuthorId(authorId: authorId);
    }
  }

  Future<List<Quote>> getAllQuotes() async {
    final query = '''
    SELECT ${Tables.quoteColumnId}, ${Tables.quoteColumnContent}, 
    ${Tables.authorTableName}.${Tables.authorColumnID}, ${Tables.authorColumnFirstName}, ${Tables.authorColumnLastName}
    FROM ${Tables.quoteTableName}
    INNER JOIN ${Tables.authorTableName}
    ON ${Tables.quoteTableName}.${Tables.quoteColumnAuthorId} == ${Tables.authorTableName}.${Tables.authorColumnID}
    ''';

    final results = await db.rawQuery(query);

    return results.map(
      (row) {
        final author = Author(
          id: row[Tables.authorColumnID] as int,
          firstName: row[Tables.authorColumnFirstName] as String,
          lastName: row[Tables.authorColumnLastName] as String,
        );

        final quote = Quote(
          id: row[Tables.quoteColumnId] as int,
          author: author,
          content: row[Tables.quoteColumnContent] as String,
        );

        return quote;
      },
    ).toList();
  }

  Future<List<Quote>> getQuotesWithAuthorId({int authorId}) async {
    final query = '''
    SELECT ${Tables.quoteColumnId}, ${Tables.quoteColumnContent}, 
    ${Tables.authorTableName}.${Tables.authorColumnID}, ${Tables.authorColumnFirstName}, ${Tables.authorColumnLastName}
    FROM ${Tables.quoteTableName}
    INNER JOIN ${Tables.authorTableName}
    ON ${Tables.quoteTableName}.${Tables.quoteColumnAuthorId} == ${Tables.authorTableName}.${Tables.authorColumnID} 
    WHERE ${Tables.quoteTableName}.${Tables.quoteColumnAuthorId} == $authorId
    ''';

    final results = await db.rawQuery(query);

    return results.map(
      (row) {
        final author = Author(
          id: row[Tables.authorColumnID] as int,
          firstName: row[Tables.authorColumnFirstName] as String,
          lastName: row[Tables.authorColumnLastName] as String,
        );

        final quote = Quote(
          id: row[Tables.quoteColumnId] as int,
          author: author,
          content: row[Tables.quoteColumnContent] as String,
        );

        return quote;
      },
    ).toList();
  }

  Future<List<Author>> getAllAuthors() async {
    final results = await db.query(Tables.authorTableName);
    return results
        .map(
          (row) => Author(
            id: row[Tables.authorColumnID] as int,
            firstName: row[Tables.authorColumnFirstName] as String,
            lastName: row[Tables.authorColumnLastName] as String,
          ),
        )
        .toList();
  }

  Future<List<Author>> getAllAuthorsOrdered() async {
    final results = await db.query(
      Tables.authorTableName,
      orderBy:
          "${Tables.authorColumnFirstName}, ${Tables.authorColumnLastName}",
    );
    return results
        .map(
          (row) => Author(
            id: row[Tables.authorColumnID] as int,
            firstName: row[Tables.authorColumnFirstName] as String,
            lastName: row[Tables.authorColumnLastName] as String,
          ),
        )
        .toList();
  }

  Future<int> getIdOfAuthorWith({String firstName, String lastName}) async {
    final results = await db.query(
      Tables.authorTableName,
      columns: [Tables.authorColumnID],
      where:
          "${Tables.authorColumnFirstName} = ? AND ${Tables.authorColumnLastName} = ?",
      whereArgs: <String>[firstName, lastName],
    );

    if (results.length == 1) {
      return results[0][Tables.authorColumnID] as int;
    } else {
      return -1;
    }
  }

  Future<Author> editAuthor({
    int authorId,
    String firstName,
    String lastName,
  }) async {
    final Map<String, String> values = {
      Tables.authorColumnFirstName: firstName,
      Tables.authorColumnLastName: lastName,
    };
    final result = await db.update(
      Tables.authorTableName,
      values,
      where: "${Tables.authorColumnID} = ?",
      whereArgs: <int>[authorId],
    );
    if (result == 1) {
      return Author(id: authorId, firstName: firstName, lastName: lastName);
    } else {
      return null;
    }
  }

  Future<Quote> editQuote({
    Quote quote,
    String newContent,
  }) async {
    final Map<String, String> values = {
      Tables.quoteColumnContent: newContent,
    };
    final result = await db.update(
      Tables.quoteTableName,
      values,
      where: "${Tables.quoteColumnId} = ?",
      whereArgs: <int>[quote.id],
    );
    if (result == 1) {
      return Quote(id: quote.id, author: quote.author, content: newContent);
    } else {
      return null;
    }
  }

  Future<void> deleteAuthor({int authorId}) async {
    await deleteQuotesWithAuthor(authorId: authorId);
    await db.delete(
      Tables.authorTableName,
      where: "${Tables.authorColumnID} = ?",
      whereArgs: <int>[authorId],
    );
  }

  Future<void> deleteQuote({int quoteId}) async {
    await db.delete(
      Tables.quoteTableName,
      where: "${Tables.quoteColumnId} = ?",
      whereArgs: <int>[quoteId],
    );
  }

  Future<void> deleteQuotesWithAuthor({int authorId}) async {
    await db.delete(
      Tables.quoteTableName,
      where: "${Tables.quoteColumnAuthorId} = ?",
      whereArgs: <int>[authorId],
    );
  }

  Future<List<Quote>> searchQuotes(List<String> words) async {
    final buffer = StringBuffer();
    buffer.write('''
    SELECT ${Tables.quoteColumnId}, ${Tables.quoteColumnContent}, 
    ${Tables.authorTableName}.${Tables.authorColumnID}, ${Tables.authorColumnFirstName}, ${Tables.authorColumnLastName}
    FROM ${Tables.quoteTableName}
    INNER JOIN ${Tables.authorTableName}
    ON ${Tables.quoteTableName}.${Tables.quoteColumnAuthorId} == ${Tables.authorTableName}.${Tables.authorColumnID}
    ''');

    if (words.isNotEmpty) {
      buffer.write(" WHERE ");

      for (int i = 0; i < words.length; i++) {
        final word = words[i].replaceAll('\'', '\'\'');
        buffer.write('''
            ${Tables.quoteColumnContent} || ${Tables.authorColumnFirstName} || ${Tables.authorColumnLastName} 
            LIKE '%$word%'
            ''');
        if (i != words.length - 1) {
          buffer.write(" AND ");
        }
      }
    }

    final results = await db.rawQuery(buffer.toString());

    return results.map(
      (row) {
        final author = Author(
          id: row[Tables.authorColumnID] as int,
          firstName: row[Tables.authorColumnFirstName] as String,
          lastName: row[Tables.authorColumnLastName] as String,
        );

        final quote = Quote(
          id: row[Tables.quoteColumnId] as int,
          author: author,
          content: row[Tables.quoteColumnContent] as String,
        );

        return quote;
      },
    ).toList();
  }
}
