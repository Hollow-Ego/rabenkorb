import 'package:rabenkorb/abstracts/PreferenceService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService extends PreferenceService {
  late final SharedPreferences? _prefs;

  Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  @override
  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  @override
  bool getBool(String key) {
    return _prefs!.getBool(key)!;
  }

  @override
  double getDouble(String key) {
    return _prefs!.getDouble(key)!;
  }

  @override
  int getInt(String key) {
    return _prefs!.getInt(key)!;
  }

  @override
  String getString(String key) {
    return _prefs!.getString(key)!;
  }

  @override
  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  @override
  Future<bool> clear() async {
    return await _prefs!.clear();
  }
}
