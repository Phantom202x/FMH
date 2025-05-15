import "package:flutter_bloc/flutter_bloc.dart";
import "package:equatable/equatable.dart";

part "navigation_state.dart";
part "navigation_event.dart";

class AppBloc extends Bloc<NavigationEvent, NavigationState> {
  AppBloc() : super(NavigationInitial()) {
    on<NavigationEvent>((event, emit) async {
      if (event is GoToWelcomePage) {
        emit(WelcomePageState());
      }
      if (event is GoToLoginPage) {
        emit(LoginPageState());
      }
      if (event is GoToRegisterPage) {
        emit(RegisterPageState());
      }
      if (event is GoToAppPage) {
        emit(AppPageState());
      }
      if (event is GoToSettings) {
        emit(SettingsPageState());
      }
    });
  }
}
