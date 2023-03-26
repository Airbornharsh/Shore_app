import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetting with ChangeNotifier {
  bool darkMode = false;

  bool get getdarkMode {
    return darkMode;
  }

  void setDarkMode(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    darkMode = val;
    prefs.setBool("shore_darkMode", val);
    notifyListeners();
  }

  void onLoad() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("shore_darkMode")) {
      darkMode = prefs.getBool("shore_darkMode")!;
    }
  }
}
