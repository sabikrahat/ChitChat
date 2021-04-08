import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  accentColor: Colors.indigo[900],
  snackBarTheme: SnackBarThemeData(
    elevation: 20.0,
    backgroundColor: Colors.black87,
    contentTextStyle: TextStyle(color: Colors.white),
    actionTextColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: Colors.indigo[400],
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  fontFamily: GoogleFonts.lato().fontFamily,
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: Colors.indigo[900],
  snackBarTheme: SnackBarThemeData(
    elevation: 20.0,
    backgroundColor: Colors.black87,
    contentTextStyle: TextStyle(color: Colors.white),
    actionTextColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  fontFamily: GoogleFonts.lato().fontFamily,
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }
}
