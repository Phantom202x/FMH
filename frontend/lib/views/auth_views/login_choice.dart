import 'package:app/views/auth_views/admin_login_view.dart';
import 'package:app/views/auth_views/guest_login_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginChoice extends StatelessWidget {
  const LoginChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 200),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset('assets/logo/logo.png'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Choose your login',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 28,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Statue',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: 317,
                      height: 51,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const AdminLoginView()),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF39CC20),
                        ),
                        child: Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: 317,
                      height: 51,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const GuestLoginView()),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF39CC20),
                        ),
                        child: Text(
                          'Guest',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Aides and Services',
                        style: TextStyle(color: const Color(0xFF39CC20)),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
