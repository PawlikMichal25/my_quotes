import 'package:flutter/foundation.dart';

class Author {
  final int key;
  final String firstName;
  final String lastName;

  const Author({
    this.key = -1,
    @required this.firstName,
    @required this.lastName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Author &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          firstName == other.firstName &&
          lastName == other.lastName;

  @override
  int get hashCode => key.hashCode ^ firstName.hashCode ^ lastName.hashCode;

  @override
  String toString() {
    return 'Author{key: $key, firstName: $firstName, lastName: $lastName}';
  }
}
