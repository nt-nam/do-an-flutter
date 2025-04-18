// lib/utils/app_theme.dart
import 'package:flutter/material.dart';
import '../../domain/entities/settings.dart'; // Import để sử dụng ThemeColor

class AppTheme {
  // Hàm tạo ThemeData dựa trên themeColor
  static ThemeData getThemeData(ThemeColor themeColor, bool isDarkMode) {
    // Ánh xạ ThemeColor tới MaterialColor
    final Map<ThemeColor, MaterialColor> colorMap = {
      ThemeColor.Teal: Colors.teal,
      ThemeColor.Blue: Colors.blue,
      ThemeColor.Red: Colors.red,
      // Thêm các màu khác nếu cần
    };

    final primarySwatch = colorMap[themeColor] ?? Colors.teal; // Mặc định là teal

    return ThemeData(
      primarySwatch: primarySwatch,
      scaffoldBackgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySwatch,
        foregroundColor: isDarkMode ? Colors.white : Colors.white,
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySwatch,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );
  }
}