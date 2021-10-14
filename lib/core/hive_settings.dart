// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// A cache access provider class for shared preferences using Hive library
class HiveCache extends CacheProvider {
  late Box _preferences;
  final String keyName = 'app_preferences';

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      final defaultDirectory = await getApplicationDocumentsDirectory();
      Hive.init(defaultDirectory.path);
    }
    if (Hive.isBoxOpen(keyName)) {
      _preferences = Hive.box(keyName);
    } else {
      _preferences = await Hive.openBox(keyName);
    }
  }

  Set get keys => getKeys();

  @override
  bool getBool(String key) {
    return _preferences.get(key);
  }

  @override
  double getDouble(String key) {
    return _preferences.get(key);
  }

  @override
  int getInt(String key) {
    return _preferences.get(key);
  }

  @override
  String getString(String key) {
    return _preferences.get(key);
  }

  @override
  Future<void> setBool(String key, bool? value, {bool? defaultValue}) {
    return _preferences.put(key, value ?? defaultValue);
  }

  @override
  Future<void> setDouble(String key, double? value, {double? defaultValue}) {
    return _preferences.put(key, value ?? defaultValue);
  }

  @override
  Future<void> setInt(String key, int? value, {int? defaultValue}) {
    return _preferences.put(key, value ?? defaultValue);
  }

  @override
  Future<void> setString(String key, String? value, {String? defaultValue}) {
    return _preferences.put(key, value ?? defaultValue);
  }

  @override
  Future<void> setObject<T>(String key, T value) {
    return _preferences.put(key, value);
  }

  @override
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  @override
  Set getKeys() {
    return _preferences.keys.toSet();
  }

  @override
  Future<void> remove(String key) async {
    if (containsKey(key)) {
      await _preferences.delete(key);
    }
  }

  @override
  Future<void> removeAll() async {
    final keys = getKeys();
    await _preferences.deleteAll(keys);
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    var value = _preferences.get(key);
    if (value is T) {
      return value;
    }
    return defaultValue;
  }
}
