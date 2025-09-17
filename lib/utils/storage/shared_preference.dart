import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  // keys for storing data
  static const TOKEN = "token";
  static const USER_ID = "user_id";
  static const SKILL_PARAMS = "skill_params";
  static const USER_TYPE = "user_type";
  static const USER_NAME = "user_name";
  static const USER_EMAIL = "user_email";
  static PreferencesManager get instance => _instance;

  // Singleton instance
  static final PreferencesManager _instance = PreferencesManager._internal();

  // SharedPreference instance
  late final SharedPreferences _prefs;

  // Private constructor
  PreferencesManager._internal();

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  // factory method to initialize the sharedpreference
  static Future<PreferencesManager> create(SharedPreferences prefs) async {
    _instance._prefs = prefs;
    return _instance;
  }

  Future<void> setToken(String tkn) async {
    await _prefs.setString(TOKEN, tkn);
  }

  String? getToken() {
    return _prefs.getString(TOKEN);
  }

  Future<void> setUserId(String user_id) async {
    await _prefs.setString(USER_ID, user_id);
  }

  String? getUserId() {
    return _prefs.getString(USER_ID);
  }

  Future<void> setSkillParams(Map<String, dynamic> skillParams) async {
    final skillInString = jsonEncode(skillParams);
    await _prefs.setString(SKILL_PARAMS, skillInString);
  }

  String? getSkillParams() {
    return _prefs.getString(SKILL_PARAMS);
  }

  Future<void> setUserType(String user_type) async {
    await _prefs.setString(USER_TYPE, user_type);
  }

  String? getUserType() {
    return _prefs.getString(USER_TYPE);
  }

  Future<void> clear(String key) async {
    await _prefs.remove(key);
  }
}
