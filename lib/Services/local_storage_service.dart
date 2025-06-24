import 'dart:convert';

import 'package:saibya_daily/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String isLoggedInKey = 'is_logged_in';
  static const String accessTokenKey = 'access_token';
  static const String userModelKey = 'user_model';

  static late LocalStorageService instance;
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    instance = LocalStorageService();
    _preferences = await SharedPreferences.getInstance();
  }

  dynamic _getFromDisk(String key) => _preferences.get(key);

  void _saveToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences.setString(key, content);
    } else if (content is bool) {
      _preferences.setBool(key, content);
    } else if (content is int) {
      _preferences.setInt(key, content);
    } else if (content is double) {
      _preferences.setDouble(key, content);
    } else if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  // Login State
  bool get isLoggedIn => _getFromDisk(isLoggedInKey) ?? false;
  set isLoggedIn(bool val) => _saveToDisk(isLoggedInKey, val);

  // Access Token
  String get accessToken => _getFromDisk(accessTokenKey) ?? '';
  set accessToken(String val) => _saveToDisk(accessTokenKey, val);

  // User Data
  UserModel get userData {
    final data = _getFromDisk(userModelKey);
    return data != null ? UserModel.fromJson(json.decode(data)) : UserModel();
  }

  set userData(UserModel val) =>
      _saveToDisk(userModelKey, json.encode(val.toJson()));

  // Clear Storage
  void clearLocalStorage() {
    _preferences.remove(accessTokenKey);
  }
}
