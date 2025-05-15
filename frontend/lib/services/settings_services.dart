import 'package:shared_preferences/shared_preferences.dart';

class SettingsServices {
  Future setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", language);
  }

  Future getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("language") ?? "en";
  }
}
