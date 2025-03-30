import 'package:equatable/equatable.dart';
import '../../../../domain/entities/settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class ToggleThemeMode extends SettingsEvent {
  final bool isDarkMode;

  const ToggleThemeMode(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

class ChangeThemeColor extends SettingsEvent {
  final ThemeColor color;

  const ChangeThemeColor(this.color);

  @override
  List<Object?> get props => [color];
}

class ChangeLanguage extends SettingsEvent {
  final Language language;

  const ChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

class ToggleSound extends SettingsEvent {
  final bool isEnabled;

  const ToggleSound(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}