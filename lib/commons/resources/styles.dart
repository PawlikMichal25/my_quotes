import 'package:flutter/material.dart';

class Styles {
  Styles._();

  static final _theme = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
    primaryColor: primaryColor,
    primaryColorBrightness: Brightness.dark,
    accentColor: accentColor,
    accentColorBrightness: Brightness.dark,
    buttonTheme: _buttonTheme,
    textSelectionColor: Colors.blue[200],
    textSelectionHandleColor: Colors.orange[800],
    indicatorColor: Colors.white,
    floatingActionButtonTheme: _floatingActionButtonTheme,
  );

  static final _buttonTheme = ThemeData.dark().buttonTheme.copyWith(
        buttonColor: primaryColor,
      );

  static final _floatingActionButtonTheme =
      ThemeData.light().floatingActionButtonTheme.copyWith(
            backgroundColor: primaryColor,
          );

  static ThemeData get theme => _theme;

  static Color get accentColor => Colors.amber;

  static Color get accentTextColor => Colors.orange;

  static Color get primaryColor => Colors.blue[700];

  static Color get primaryTextColor => Colors.white;

  static Color get darkGrey => Colors.grey[700];

  static Color get lightGrey => Color(0xFF9A9A9A);

  static Color get errorRed => Colors.red[700];

  static Color get linkColor => Color(0xFF0645AD);
}
