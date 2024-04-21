abstract class PreferenceService {
  Future<bool> setBool(String key, bool value);

  Future<bool> setDouble(String key, double value);

  Future<bool> setInt(String key, int value);

  Future<bool> setString(String key, String value);

  bool? getBool(String key);

  double? getDouble(String key);

  int? getInt(String key);

  String? getString(String key);

  Future<bool> remove(String key);

  Future<bool> clear();
}
