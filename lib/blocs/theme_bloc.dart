import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc with ChangeNotifier {
  ThemeData _theme;
  String _themeName = 'Light';

  ThemeBloc(this._theme);

  ThemeData getTheme() => _theme;
  String getThemeName() => _themeName;
  bool isDarkTheme() => _themeName == 'Dark';

  void setTheme(String themeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _theme = themeName == 'Light' ? kThemeData : kThemeDataDark;
    _themeName = themeName;
    prefs.setString(kThemeLocal, _themeName);
    notifyListeners();
  }

  getThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getAppTheme = prefs.getString(kThemeLocal);
    if (getAppTheme == 'Dark') {
      _theme = kThemeDataDark;
      _themeName = 'Dark';
    } else {
      _theme = kThemeData;
      _themeName = 'Light';
    }
    return _theme;
  }
}
