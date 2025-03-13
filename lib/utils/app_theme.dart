// lib/utils/app_theme.dart
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Thay headline6
    bodyMedium: TextStyle(fontSize: 16), // Thay bodyText2
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Thay primary
      foregroundColor: Colors.white, // Thay onPrimary
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
);