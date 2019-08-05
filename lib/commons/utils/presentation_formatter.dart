import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';

class PresentationFormatter {
  static String formatAuthor(Author author) {
    return '${author.firstName} ${author.lastName}';
  }

  static String formatQuoteForSharing(Quote quote) {
    return '"${quote.content}" ${formatAuthor(quote.author)}';
  }
}
