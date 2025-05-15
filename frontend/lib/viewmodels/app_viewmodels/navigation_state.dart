part of "app_bloc.dart";

abstract class NavigationState extends Equatable {
  const NavigationState();
}

class NavigationInitial extends NavigationState {
  @override
  List<Object> get props => [];
}

class WelcomePageState extends NavigationInitial {}

class LoginPageState extends NavigationInitial {}

class RegisterPageState extends NavigationInitial {}

class AppPageState extends NavigationInitial {}

class SettingsPageState extends NavigationInitial {}
