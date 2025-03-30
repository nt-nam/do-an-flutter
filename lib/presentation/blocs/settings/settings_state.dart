import 'package:equatable/equatable.dart';
import '../../../../domain/entities/settings.dart';

class SettingsState extends Equatable {
  final Settings settings;

  const SettingsState(this.settings);

  @override
  List<Object?> get props => [settings];
}