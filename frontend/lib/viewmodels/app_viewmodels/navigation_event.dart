part of "app_bloc.dart";

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class NavigationMain extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class GoToWelcomePage extends NavigationMain {}

class GoToLoginPage extends NavigationMain {}

class GoToRegisterPage extends NavigationMain {}

class GoToAppPage extends NavigationMain {}

class GoToSettings extends NavigationMain {}
