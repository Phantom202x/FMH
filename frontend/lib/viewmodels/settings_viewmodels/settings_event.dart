part of "settings_bloc.dart";

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ThemeEvents extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class LanguageEvents extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsInitialEvent extends SettingsEvent {}

class LanguageInitial extends LanguageEvents {}

class UpdateLanguage extends LanguageEvents {
  final Locale language;

  UpdateLanguage({required this.language});
}

class UpdateTheme extends ThemeEvents {
  final String theme;

  UpdateTheme({required this.theme});
}

class ThemeInitial extends ThemeEvents {}

class ToggleDarkMode extends ThemeEvents {}

class ToggleLightMode extends ThemeEvents {}

class ToggleSystemMode extends ThemeEvents {}

class CompleteSetup extends SettingsEvent {
  const CompleteSetup();
}
