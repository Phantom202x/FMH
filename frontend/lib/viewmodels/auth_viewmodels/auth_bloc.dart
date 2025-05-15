import 'package:app/models/auth_models.dart';
import 'package:app/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final storage = const FlutterSecureStorage();

  final AuthServices authRepo;
  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is GuestLogin) {
        var response = await authRepo.guestLogin(
          GuestUser(
            fullName: event.loginData["full_name"],
            nationality: event.loginData["nationality"],
            email: event.loginData["email"],
            phone: event.loginData["phone"],
          ),
        );
        print("GuestLogin response: ${response.user?.id}");
        if (response.user!.role == "authenticated") {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(message: "Something went wrong"));
        }
      }
      if (event is AdminLogin) {
        var response = await authRepo.adminLogin(
          AdminUser(
            email: event.email,
            password: event.password,
          ),
        );
        if (response.user!.role == "authenticated") {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(message: "Something went wrong"));
        }
      }
      if (event is Logout) {
        var response = await authRepo.logout().then((value) {
          emit(Unauthorized());
        });
      }
      if (event is DeleteAccount) {
        try {
          await authRepo.deleteGuest(); // or deleteAdmin
          emit(AccountDeleted());
        } catch (e) {
          emit(AuthFailure(message: "Failed to delete account"));
        }
      }
    });
  }
}

class AccountDeleted extends AuthState {}
