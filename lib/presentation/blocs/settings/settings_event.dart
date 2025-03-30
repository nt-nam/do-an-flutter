// lib/presentation/blocs/settings/settings_event.dart

import '../../../domain/entities/settings.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class ToggleThemeMode extends SettingsEvent {
  final bool isDarkMode;

  const ToggleThemeMode(this.isDarkMode);
}

class ChangeThemeColor extends SettingsEvent {
  final ThemeColor color;

  const ChangeThemeColor(this.color);
}

class ChangeLanguage extends SettingsEvent {
  final Language language;

  const ChangeLanguage(this.language);
}

class ToggleSound extends SettingsEvent {
  final bool isEnabled;

  const ToggleSound(this.isEnabled);
}