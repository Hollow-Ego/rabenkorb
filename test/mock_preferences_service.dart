import 'package:rabenkorb/abstracts/PreferenceService.dart';

class MockPreferenceService extends PreferenceService {
  final Map<String, dynamic> _storage = {};

  @override
  Future<bool> clear() async {
    _storage.clear();
    return true;
  }

  @override
  bool? getBool(String key) {
    return _storage[key];
  }

  @override
  double? getDouble(String key) {
    return _storage[key];
  }

  @override
  int? getInt(String key) {
    return _storage[key];
  }

  @override
  String? getString(String key) {
    return _storage[key];
  }

  @override
  Future<bool> remove(String key) async {
    _storage.remove(key);
    return true;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }
}
