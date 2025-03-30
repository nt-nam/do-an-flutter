// lib/presentation/pages/screens/settings/SettingsScreen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/settings/settings_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/settings/settings_event.dart';
import 'package:do_an_flutter/presentation/blocs/settings/settings_state.dart';
import 'package:do_an_flutter/domain/entities/settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cài đặt',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.teal),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final settings = state.settings;
              return ListView(
                children: [
                  // Chế độ sáng/tối
                  ListTile(
                    leading: const Icon(Icons.brightness_6, color: Colors.teal),
                    title: const Text('Chế độ sáng/tối'),
                    trailing: Switch(
                      value: settings.themeMode == ThemeModeOption.dark,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleThemeMode(value));
                        // TODO: Áp dụng chế độ sáng/tối cho toàn ứng dụng
                      },
                      activeColor: Colors.teal,
                    ),
                  ),
                  // Màu sắc
                  ListTile(
                    leading: const Icon(Icons.color_lens, color: Colors.teal),
                    title: const Text('Màu sắc chủ đạo'),
                    trailing: DropdownButton<ThemeColor>(
                      value: settings.themeColor,
                      onChanged: (ThemeColor? newValue) {
                        if (newValue != null) {
                          context.read<SettingsBloc>().add(ChangeThemeColor(newValue));
                          // TODO: Áp dụng màu sắc cho toàn ứng dụng
                        }
                      },
                      items: ThemeColor.values.map((ThemeColor color) {
                        return DropdownMenuItem<ThemeColor>(
                          value: color,
                          child: Text(
                            color.toString().split('.').last,
                            style: const TextStyle(color: Colors.teal),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Ngôn ngữ
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.teal),
                    title: const Text('Ngôn ngữ'),
                    trailing: DropdownButton<Language>(
                      value: settings.language,
                      onChanged: (Language? newValue) {
                        if (newValue != null) {
                          context.read<SettingsBloc>().add(ChangeLanguage(newValue));
                          // TODO: Áp dụng ngôn ngữ cho toàn ứng dụng
                        }
                      },
                      items: Language.values.map((Language lang) {
                        return DropdownMenuItem<Language>(
                          value: lang,
                          child: Text(
                            lang == Language.vietnamese ? 'Tiếng Việt' : 'Tiếng Anh',
                            style: const TextStyle(color: Colors.teal),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Âm thanh
                  ListTile(
                    leading: const Icon(Icons.volume_up, color: Colors.teal),
                    title: const Text('Âm thanh'),
                    trailing: Switch(
                      value: settings.soundEnabled,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleSound(value));
                        // TODO: Bật/tắt âm thanh cho ứng dụng
                      },
                      activeColor: Colors.teal,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}