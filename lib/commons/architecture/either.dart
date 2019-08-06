class Either<L, R> {
  L _left;
  R _right;

  Either.left(this._left);

  Either.right(this._right);

  bool isLeft() => _left != null;

  bool isRight() => _right != null;

  @override
  String toString() {
    return 'Either{_left: $_left, _right: $_right}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Either &&
          runtimeType == other.runtimeType &&
          _left == other._left &&
          _right == other._right;

  @override
  int get hashCode => _left.hashCode ^ _right.hashCode;

  R get right => _right;

  L get left => _left;
}
