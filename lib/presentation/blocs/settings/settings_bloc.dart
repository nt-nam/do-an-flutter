import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(Settings(
    themeMode: ThemeModeOption.light,
    themeColor: ThemeColor.teal,
    language: Language.vietnamese,
    soundEnabled: true,
  ))) {
    _loadSettings(); // Tải cài đặt khi khởi tạo
    on<ToggleThemeMode>(_onToggleThemeMode);
    on<ChangeThemeColor>(_onChangeThemeColor);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ToggleSound>(_onToggleSound);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString('themeMode') == 'dark'
        ? ThemeModeOption.dark
        : ThemeModeOption.light;
    final themeColor = ThemeColor.values.firstWhere(
          (color) => color.toString() == prefs.getString('themeColor'),
      orElse: () => ThemeColor.teal,
    );
    final language = prefs.getString('language') == 'english'
        ? Language.english
        : Language.vietnamese;
    final soundEnabled = prefs.getBool('soundEnabled') ?? true;

    emit(SettingsState(Settings(
      themeMode: themeMode,
      themeColor: themeColor,
      language: language,
      soundEnabled: soundEnabled,
    )));
  }

  Future<void> _saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'themeMode', settings.themeMode == ThemeModeOption.dark ? 'dark' : 'light');
    await prefs.setString('themeColor', settings.themeColor.toString());
    await prefs.setString(
        'language', settings.language == Language.english ? 'english' : 'vietnamese');
    await prefs.setBool('soundEnabled', settings.soundEnabled);
  }

  Future<void> _onToggleThemeMode(ToggleThemeMode event, Emitter<SettingsState> emit) async {
    final newSettings = state.settings.copyWith(
      themeMode: event.isDarkMode ? ThemeModeOption.dark : ThemeModeOption.light,
    );
    emit(SettingsState(newSettings));
    await _saveSettings(newSettings);
  }

  Future<void> _onChangeThemeColor(ChangeThemeColor event, Emitter<SettingsState> emit) async {
    final newSettings = state.settings.copyWith(themeColor: event.color);
    emit(SettingsState(newSettings));
    await _saveSettings(newSettings);
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<SettingsState> emit) async {
    final newSettings = state.settings.copyWith(language: event.language);
    emit(SettingsState(newSettings));
    await _saveSettings(newSettings);
  }

  Future<void> _onToggleSound(ToggleSound event, Emitter<SettingsState> emit) async {
    final newSettings = state.settings.copyWith(soundEnabled: event.isEnabled);
    emit(SettingsState(newSettings));
    await _saveSettings(newSettings);
  }
}