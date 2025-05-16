import 'package:app/components/hadj_input.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/views/app_views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordConfirm extends StatefulWidget {
  const PasswordConfirm({super.key});

  @override
  State<PasswordConfirm> createState() => _PasswordConfirmState();
}

class _PasswordConfirmState extends State<PasswordConfirm> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset('assets/logo/logo.png'),
              ),
              SizedBox(height: 40),
              Text(
                l10n.create_your_password,
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 28),
              ),
              SizedBox(height: 40),
              HadjInput(
                hinttext: 'Password',
                controller: passwordController,
                isPassword: true,
                icon: Icon(Icons.remove_red_eye_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your nationality';
                  }
                  return null; // Validation passed
                },
              ),
              SizedBox(height: 20),
              HadjInput(
                hinttext: 'Confirm Password',
                controller: confirmPasswordController,
                isPassword: true,
                icon: Icon(Icons.remove_red_eye_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null; // Validation passed
                },
              ),
              SizedBox(height: 200),
              SizedBox(
                width: 320,
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainAppView()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password does not match'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39CC20),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 320,
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[350],
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
    );
  }
}
