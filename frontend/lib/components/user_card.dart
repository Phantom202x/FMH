import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String nationality;
  final String status;
  final int age;
  final String image;
  const UserCard({
    super.key,
    required this.name,
    required this.nationality,
    required this.status,
    required this.age,
    required this.image,
    });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFCBCBCB),
            Color(0xFFD2D2D2),
            Color(0xFFD9D9D9),
            Color(0xFFE0E0E0),
            Color(0xFFE7E7E7),
            Color(0xFFEEEEEE),
            Color(0xFFF5F5F5),
            Color(0xFFFAFAFA),
            Colors.white,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // control inner space
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/logo/user.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF39CC20),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Missing 3h ago',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            /// Blue Info Boxes
            Container(
              // margin: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      //width: screenWidth * 0.4,
                      margin: const EdgeInsets.only(left: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9F7F7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      //width: screenWidth * 0.4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9F7F7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '70',
                            //'${age}',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            nationality,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
