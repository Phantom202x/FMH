import 'package:app/services/auth_services.dart';
import 'package:app/viewmodels/auth_viewmodels/auth_bloc.dart';
import 'package:app/views/settings_views/languages_view.dart';
import 'package:app/views/settings_views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late AuthBloc authBloc;
  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          l10n.settings_title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: size.width,
        child: Column(
          spacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileView(
                    userInfo:AuthServices().getUserInfos(),
                  ),
                ),
              ),
              icon: Icon(Icons.person_outline_rounded),
              label: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(l10n.profile),
                  const Spacer(),
                ],
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                fixedSize: Size(size.width, 56),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                iconSize: 22,
                iconColor: Colors.black,
                foregroundColor: Colors.black,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LanguagesView(),
                ),
              ),
              icon: Icon(Icons.language),
              label: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(l10n.language),
                  const Spacer()
                ],
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                fixedSize: Size(size.width, 56),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                iconSize: 22,
                iconColor: Colors.black,
                foregroundColor: Colors.black,
              ),
            ),
            //OutlinedButton.icon(
            //  onPressed: () {},
            //  icon: Icon(Icons.change_circle),
            //  label: Row(
            //    children: [
            //      const SizedBox(width: 10),
            //      Text("Change Password"),
            //      const Spacer()
            //    ],
            //  ),
            //  style: OutlinedButton.styleFrom(
            //    side: BorderSide(color: Colors.grey.shade300),
            //    fixedSize: Size(size.width, 56),
            //    padding: const EdgeInsets.only(left: 24),
            //    iconSize: 22,
            //    iconColor: Colors.black,
            //    foregroundColor: Colors.black,
            //  ),
            //),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                authBloc.add(Logout());
                Navigator.pushReplacementNamed(context, '/');
              },
              label: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(l10n.logout),
                  const Spacer(),
                ],
              ),
              icon: Icon(Icons.logout),
              style: OutlinedButton.styleFrom(
                fixedSize: Size(size.width, 56),
                padding: const EdgeInsets.only(left: 24),
                iconSize: 22,
                iconColor: Colors.red,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
