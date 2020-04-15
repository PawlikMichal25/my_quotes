import 'package:flutter/foundation.dart';

class BaseNotifier<S> extends ChangeNotifier {
  S _state;

  S get state => _state;

  void updateState(S state) {
    _state = state;
  }
}
