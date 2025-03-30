// lib/presentation/blocs/settings/settings_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_flutter/domain/entities/settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(SettingsState(Settings(
    themeMode: ThemeModeOption.light,
    themeColor: ThemeColor.teal,
    language: Language.vietnamese,
    soundEnabled: true,
  ))) {
    on<ToggleThemeMode>(_onToggleThemeMode);
    on<ChangeThemeColor>(_onChangeThemeColor);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ToggleSound>(_onToggleSound);
  }

  void _onToggleThemeMode(ToggleThemeMode event, Emitter<SettingsState> emit) {
    emit(SettingsState(state.settings.copyWith(
      themeMode: event.isDarkMode ? ThemeModeOption.dark : ThemeModeOption.light,
    )));
  }

  void _onChangeThemeColor(ChangeThemeColor event, Emitter<SettingsState> emit) {
    emit(SettingsState(state.settings.copyWith(themeColor: event.color)));
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<SettingsState> emit) {
    emit(SettingsState(state.settings.copyWith(language: event.language)));
  }

  void _onToggleSound(ToggleSound event, Emitter<SettingsState> emit) {
    emit(SettingsState(state.settings.copyWith(soundEnabled: event.isEnabled)));
  }
}