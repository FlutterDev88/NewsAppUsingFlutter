import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/shared_preference_keys.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier {
  final _userService = UserService();
  SharedPreferences _prefs;
  UserModel _user;
  String _email;
  bool _isInitialized;
  bool _isFirstLogin;
  bool loading = false;
  
  UserModel get user => _user;
  String get email => _email;
  bool get isFirstLogin => _isFirstLogin;

  UserBloc() {
    _initializePreferences();
  }

  Future<String> login(String username, String password) async {
    try {
      _email = username;
      _prefs.setString(SharedPreferenceKeys.EMAIL, username);

      final result = await AuthService.login(username, password);

      if (result) {
        _user = await _userService.getUser();
      }

      notifyListeners();
    }
    catch (ex) {
      return ex.toString();
    }

    return null;
  }

  Future<bool> tryInitializeUser() async {
    if (_isInitialized == true) {
      return true;
    }

    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    _email = _prefs.getString(SharedPreferenceKeys.EMAIL);
    final token = _prefs.getString(SharedPreferenceKeys.TOKEN);

    if (token == null) {
      return false;
    }

    try {
      _user = await _userService.getUser();
      _email = _user.email;
      // _themeProvider.setTheme(_user.theme);
      _isInitialized = true;
    } catch (ex) {
      await _prefs.remove(SharedPreferenceKeys.TOKEN);
      return false;
    }

    return true;
  }

  Future updateUser() async {
    try {
      _user = await _userService.getUser();
      _email = _user.email;
      // _themeProvider.setTheme(_user.theme);
      notifyListeners();
    } catch (ex) {
      print('could not update user. $ex');
    }
  }

  Future logout() async {
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }

  Future setFirstTimeLogin(bool isFirstLogin) async {
    _isFirstLogin = isFirstLogin;
    await _prefs.setBool(SharedPreferenceKeys.FIRST_LOGIN, _isFirstLogin);

    notifyListeners();
  }

  Future _initializePreferences() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    _email = _prefs.getString(SharedPreferenceKeys.EMAIL);

    if (_email != null && _email.isNotEmpty) {
      notifyListeners();
    }
    else {
      _isFirstLogin = true;
    }
  }
}