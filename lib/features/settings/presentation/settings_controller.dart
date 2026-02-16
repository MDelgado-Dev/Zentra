import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.locale,
    required this.offlineMode,
    required this.syncEnabled,
    required this.biometricLock,
  });

  final ThemeMode themeMode;
  final Locale? locale;
  final bool offlineMode;
  final bool syncEnabled;
  final bool biometricLock;

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? offlineMode,
    bool? syncEnabled,
    bool? biometricLock,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      offlineMode: offlineMode ?? this.offlineMode,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      biometricLock: biometricLock ?? this.biometricLock,
    );
  }

  static const SettingsState initial = SettingsState(
    themeMode: ThemeMode.system,
    locale: null,
    offlineMode: true,
    syncEnabled: false,
    biometricLock: false,
  );
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(SettingsState.initial) {
    _load();
  }

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _offlineKey = 'offline_mode';
  static const _syncKey = 'sync_enabled';
  static const _biometricKey = 'biometric_lock';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    final localeCode = prefs.getString(_localeKey);

    state = state.copyWith(
      themeMode: themeIndex != null
          ? ThemeMode.values[themeIndex]
          : state.themeMode,
      locale: localeCode != null ? Locale(localeCode) : null,
      offlineMode: prefs.getBool(_offlineKey) ?? state.offlineMode,
      syncEnabled: prefs.getBool(_syncKey) ?? state.syncEnabled,
      biometricLock: prefs.getBool(_biometricKey) ?? state.biometricLock,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> setLocale(Locale? locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
    }
  }

  Future<void> setOfflineMode(bool value) async {
    state = state.copyWith(offlineMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offlineKey, value);
  }

  Future<void> setSyncEnabled(bool value) async {
    state = state.copyWith(syncEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_syncKey, value);
  }

  Future<void> setBiometricLock(bool value) async {
    state = state.copyWith(biometricLock: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, value);
  }
}
