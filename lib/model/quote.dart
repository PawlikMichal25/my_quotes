import 'package:flutter/foundation.dart';

import 'author.dart';

class Quote {
  final int id;
  final Author author;
  final String content;

  const Quote({
    this.id = -1,
    @required this.author,
    @required this.content,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          author == other.author &&
          content == other.content;

  @override
  int get hashCode => id.hashCode ^ author.hashCode ^ content.hashCode;

  @override
  String toString() {
    return 'Quote{id: $id, author: $author, content: $content}';
  }
}
