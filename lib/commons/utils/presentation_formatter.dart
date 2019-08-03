import 'package:my_quotes/model/author.dart';

class PresentationFormatter {
  static String formatAuthor(Author author) {
    return '${author.firstName} ${author.lastName}';
  }
}
