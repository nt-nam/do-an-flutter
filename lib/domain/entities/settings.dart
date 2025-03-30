// lib/domain/entities/settings.dart

enum ThemeModeOption {
  light,
  dark,
}

enum ThemeColor {
  teal,
  blue,
  red,
}

enum Language {
  vietnamese,
  english,
}

class Settings {
  final ThemeModeOption themeMode;
  final ThemeColor themeColor;
  final Language language;
  final bool soundEnabled;

  Settings({
    required this.themeMode,
    required this.themeColor,
    required this.language,
    required this.soundEnabled,
  });

  // Tạo bản sao với các giá trị mới
  Settings copyWith({
    ThemeModeOption? themeMode,
    ThemeColor? themeColor,
    Language? language,
    bool? soundEnabled,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
      language: language ?? this.language,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}