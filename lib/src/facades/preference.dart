import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrape_supermarkets_uruguay/src/facades/facades.dart';

class Preference {
  Preference._singleton();

  static final instance = Preference._singleton();

  final _streamController = StreamController<Preference>.broadcast();

  Stream<Preference> get stream => _streamController.stream;

  ThemeMode themeMode = ThemeMode.system;
  Locale? locale;

  final _themeModeKey = 'themeMode';
  final _localeKey = 'locale';

  Future<void> initialize() async {
    await Future.wait([
      _themeModeInit(),
      _localeInit(),
    ]);
  }

  Future<void> _themeModeInit() async {
    final value = await Storage.instance.get<String>(_themeModeKey);

    switch (value) {
      case 'dark':
        themeMode = ThemeMode.dark;
      case 'light':
        themeMode = ThemeMode.light;
      default:
        themeMode = ThemeMode.system;
    }
  }

  Future<void> _localeInit() async {
    final value = await Storage.instance.get<String>(_localeKey);

    if (value != null) {
      locale = Locale(value);
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    this.themeMode = themeMode;
    _streamController.add(this);
    await Storage.instance
        .set(_themeModeKey, themeMode.toString().split('.').last);
  }

  Future<void> setLocale(Locale? locale) async {
    this.locale = locale;
    _streamController.add(this);

    if (locale == null) {
      await Storage.instance.remove(_localeKey);
      return;
    }

    await Storage.instance.set(_localeKey, locale.languageCode);
  }

  Future<void> removePreference() async {
    themeMode = ThemeMode.system;
    locale = null;

    _streamController.add(this);

    await Storage.instance.remove(_themeModeKey);
    await Storage.instance.remove(_localeKey);
  }

  Future<void> dispose() async {
    await _streamController.close();
  }
}
