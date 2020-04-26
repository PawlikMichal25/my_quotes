import 'package:flutter/foundation.dart';

import 'author.dart';

class Quote {
  final int key;
  final Author author;
  final String content;

  const Quote({
    this.key = -1,
    @required this.author,
    @required this.content,
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
