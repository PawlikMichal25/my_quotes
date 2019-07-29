import 'package:flutter/foundation.dart';

class Author {
  final int id;
  final String firstName;
  final String lastName;

  const Author({
    this.id = -1,
    @required this.firstName,
    @required this.lastName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Author &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName;

  @override
  int get hashCode => id.hashCode ^ firstName.hashCode ^ lastName.hashCode;

  @override
  String toString() {
    return 'Author{id: $id, firstName: $firstName, lastName: $lastName}';
  }
}
