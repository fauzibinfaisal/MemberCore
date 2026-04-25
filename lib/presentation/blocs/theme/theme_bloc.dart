import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences prefs;

  ThemeBloc({required this.prefs}) : super(_getInitialState(prefs)) {
    on<ToggleTheme>(_onToggleTheme);
  }

  static ThemeState _getInitialState(SharedPreferences prefs) {
    final themeString = prefs.getString(_themeKey);
    ThemeMode mode;
    switch (themeString) {
      case 'dark':
        mode = ThemeMode.dark;
        break;
      case 'light':
        mode = ThemeMode.light;
        break;
      default:
        mode = ThemeMode.system;
        break;
    }
    return ThemeState(themeMode: mode);
  }

  Future<void> _onToggleTheme(
      ToggleTheme event,
      Emitter<ThemeState> emit,
      ) async {
    String themeString;
    switch (event.themeMode) {
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.light:
        themeString = 'light';
        break;
      default:
        themeString = 'system';
        break;
    }

    await prefs.setString(_themeKey, themeString);
    emit(ThemeState(themeMode: event.themeMode));
  }
}
