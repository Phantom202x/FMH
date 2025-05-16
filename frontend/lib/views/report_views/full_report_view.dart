import 'dart:io';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/face_scan_services.dart';
import 'package:app/views/face_scan_views/face_scan_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FullReportView extends StatelessWidget {
  final Map data;
  final File? image;

  const FullReportView({this.image, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    print("FullReportView -> Received data:");
    data.forEach((key, value) {
      print("$key: $value");
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              foregroundImage: image != null ? FileImage(image!) : null,
              child: image == null ? Icon(Icons.person, size: 60) : null,
            ),
            SizedBox(height: 10),
            Text(
              (data["full_name"] ?? "Unknown").toString(),
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // Personal Information Cards
            _buildInfoCard(l10n.age, data["age"]?.toString()),
            _buildInfoCard(l10n.nationality, data["nationality"]?.toString()),
            _buildInfoCard(l10n.blood_type, data["blood_type"]?.toString()),
            _buildInfoCard(l10n.gender, data["gender"]?.toString()),
            _buildInfoCard(
              l10n.emergency_contact,
              (data["contact"] ?? (data["phone_number"] ?? "-")?.toString()),
            ),
            _buildInfoCard(l10n.illness, (data["illness"] ?? "-")?.toString()),

            SizedBox(height: 100),

            // Emergency Button
            FilledButton(
              onPressed: () {},
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(Size(size.width - 32, 50)),
                backgroundColor: WidgetStateProperty.all(Colors.green),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: Text(l10n.call_emergency),
            ),
            // Face Scan Button
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                await FaceScanServices().getImageFromCamera().then((value) {
                  if (value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.no_image_taken)));
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FaceScanView(image: value)),
                  );
                });
              },
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(Size(size.width - 32, 50)),
                foregroundColor: WidgetStateProperty.all(Colors.green),
                side: WidgetStateProperty.all(
                    BorderSide(color: Colors.green, width: 2)),
              ),
              child: Text(
                l10n.scan_face,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0x1F39CC20),
      ),
      child: Row(
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Spacer(),
          Text(
            value ?? "-",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
