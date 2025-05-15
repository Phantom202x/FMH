import 'package:app/components/hadj_input.dart';
import 'package:app/viewmodels/app_viewmodels/app_bloc.dart';
import 'package:app/viewmodels/auth_viewmodels/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuestLoginView extends StatefulWidget {
  const GuestLoginView({super.key});

  @override
  State<GuestLoginView> createState() => _GuestLoginViewState();
}

class _GuestLoginViewState extends State<GuestLoginView> {
  late AuthBloc authBloc;
  late AppBloc navigationBloc;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nationality_Controller = TextEditingController();
  String nationality = "";

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    navigationBloc = BlocProvider.of<AppBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    navigationBloc.add(GoToWelcomePage());
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
          )
        ],
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Image(
                    image: AssetImage("assets/logo/logo.png"),
                  ),
                  SizedBox(height: 100),
                  HadjInput(
                    hinttext: l10n.name_hint,
                    controller: nameController,
                    icon: Icon(
                      Icons.person_outline_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null; // Validation passed
                    },
                  ),
                  SizedBox(height: 20),
                  HadjInput(
                    hinttext: l10n.email_hint,
                    controller: emailController,
                    icon: Icon(
                      Icons.email_outlined,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  HadjInput(
                    textInputAction: TextInputAction.next,
                    onTap: () => showCountryPicker(
                      context: context,
                      onSelect: (Country country) => setState(() {
                        nationality = country.name;
                        nationality_Controller.text = country.name;
                      }),
                    ),
                    hinttext: l10n.nationality,
                    controller: nationality_Controller,
                    icon: Icon(
                      Icons.flag_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your nationality';
                      }
                      return null; // Validation passed
                    },
                  ),
                  SizedBox(height: 20),
                  HadjInput(
                    hinttext: l10n.phone_hint,
                    controller: phoneController,
                    icon: Icon(
                      Icons.phone_outlined,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Only allows digits
                      LengthLimitingTextInputFormatter(
                          15), // Limits to 15 digits
                    ],
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        return 'Please enter your phone number';
                      }
                      return null; // Validation passed
                    },
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          nationality != "") {
                        authBloc.add(
                          GuestLogin(
                            loginData: {
                              "full_name": nameController.text,
                              "email": emailController.text,
                              "phone": phoneController.text,
                              "nationality": nationality_Controller.text,
                            },
                          ),
                        );
                      }
                      if (nationality == "" &&
                          formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.form_validate_nationality),
                          ),
                        );
                      }
                      if (!formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.form_validate),
                          ),
                        );
                      }
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //         builder: (context) => const PasswordConfirm()),
                      //     );
                    },
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(
                        Size(size.width * .7, 50),
                      ),
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text('Continue'),
                  ),
                  SizedBox(height: 10),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Text(
                  //     'Aides and Services',
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
