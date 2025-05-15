import 'package:app/services/settings_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "settings_event.dart";
part "settings_state.dart";

class SettingsBloc extends Bloc<SettingsEvent, Map<dynamic, dynamic>> {
  final SettingsServices settingsRepo;

  SettingsBloc(this.settingsRepo)
      : super({
          "language": Locale("en"),
        }) {
    on<SettingsInitialEvent>((event, emit) async {
      Map settings = await getAdditionalData();

      emit(settings);
    });

    on<UpdateLanguage>((event, emit) async {
      Map settings = await getAdditionalData();
      settingsRepo.setLanguage(event.language.languageCode);
      settings["language"] = event.language;
      emit(settings);
    });

  }
  getAdditionalData() async {
    final language = await settingsRepo.getLanguage();


    return {
      "language": Locale(language),
    };
  }
}
