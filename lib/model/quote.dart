import 'package:flutter/foundation.dart';
import 'package:my_quotes/model/author.dart';

@immutable
class Quote {
  final int key;
  final Author author;
  final String content;

  const Quote({
    required this.author,
    required this.content,
    this.key = -1,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          author == other.author &&
          content == other.content;

  @override
  int get hashCode => key.hashCode ^ author.hashCode ^ content.hashCode;

  @override
  String toString() {
    return 'Quote{key: $key, author: $author, content: $content}';
  }
}
