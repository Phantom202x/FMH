import 'package:app/components/hadj_input.dart';
import 'package:app/viewmodels/app_viewmodels/app_bloc.dart';
import 'package:app/viewmodels/auth_viewmodels/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {
  late AuthBloc authBloc;
  late AppBloc navigationBloc;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showPassword = false;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    navigationBloc = BlocProvider.of<AppBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    navigationBloc.add(GoToWelcomePage());
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                navigationBloc.add(GoToWelcomePage());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("app", (route) => false);
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 48),
            height: size.height,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Image(
                    image: AssetImage("assets/logo/logo.png"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    l10n.admin_login_title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  HadjInput(
                    hinttext: l10n.email_hint,
                    controller: emailController,
                    icon: Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.form_validate_email;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  HadjInput(
                    hinttext: l10n.password_hint,
                    controller: passwordController,
                    icon: Icon(Icons.remove_red_eye_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.form_validate_password;
                      }
                      return null;
                    },
                    isPassword: true,
                  ),
                  SizedBox(height: 150),
                  SizedBox(
                    width: 317,
                    height: 51,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authBloc.add(
                            AdminLogin(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.form_validate),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF39CC20),
                      ),
                      child: Text(
                        l10n.login_button,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 10),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Text('aides_and_services',
                  //     //l10n.aides_and_services,
                  //     style: TextStyle(color: const Color(0xFF39CC20)),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
