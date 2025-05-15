part of "settings_bloc.dart";

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
  @override
  List<Object> get props => [];
}

class BrightnessChanged extends SettingsInitial {
  final ThemeMode currentBrightness;

  const BrightnessChanged({required this.currentBrightness});
}

class ThemeChanged extends SettingsInitial {
  final ThemeMode currentTheme;

  const ThemeChanged({required this.currentTheme});
}

class LanguageChanged extends SettingsInitial {
  final Locale currentLanguage;

  const LanguageChanged({required this.currentLanguage});
}

class SetupComplete extends SettingsState {
  const SetupComplete();
  @override
  List<Object> get props => [];
}
