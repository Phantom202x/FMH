import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      height: size.height,
      child: Column(
        children: [
          SizedBox(height: 50),
          Image(
            image: AssetImage("assets/logo/logo.png"),
          ),
          SizedBox(height: 20),
          Text(
            'Searching for the the Hadjs',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Color(0xFF00CC99), Color(0xFF00BFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 5.0,
          ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Aides and Services',
              style: TextStyle(color: const Color(0xFF39CC20)),
            ),
          ),
        ],
      ),
    );
  }
}
