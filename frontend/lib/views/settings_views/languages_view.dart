import 'package:app/l10n/app_localizations.dart';
import 'package:app/viewmodels/settings_viewmodels/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagesView extends StatefulWidget {
  const LanguagesView({super.key});

  @override
  State<LanguagesView> createState() => _LanguagesViewState();
}

class _LanguagesViewState extends State<LanguagesView> {
  late SettingsBloc settingsBloc;
  @override
  void initState() {
    settingsBloc = BlocProvider.of<SettingsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: Text(
          l10n.languages,
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
            FilledButton.icon(
              onPressed: () => settingsBloc.add(
                UpdateLanguage(
                  language: Locale("en"),
                ),
              ),
              icon: Icon(Icons.language),
              label: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(l10n.english),
                  const Spacer()
                ],
              ),
              style: FilledButton.styleFrom(
                fixedSize: Size(size.width, 56),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                iconSize: 22,
                iconColor: Colors.white,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            FilledButton.icon(
              onPressed: () => settingsBloc.add(
                UpdateLanguage(
                  language: Locale("ar"),
                ),
              ),
              icon: Icon(Icons.language),
              label: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(l10n.arabic),
                  const Spacer()
                ],
              ),
              style: FilledButton.styleFrom(
                fixedSize: Size(size.width, 56),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                iconSize: 22,
                iconColor: Colors.white,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                print('Language changed');
                settingsBloc.add(
                  UpdateLanguage(
                    language: Locale("fr"),
                  ),
                );
              },
              icon: Icon(Icons.language),
              label: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(l10n.french),
                  const Spacer()
                ],
              ),
              style: FilledButton.styleFrom(
                fixedSize: Size(size.width, 56),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                iconSize: 22,
                iconColor: Colors.white,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
