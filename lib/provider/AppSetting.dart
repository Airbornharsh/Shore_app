import 'package:flutter/material.dart';
import 'package:shore_app/Utils/Prefs.dart';

class AppSetting with ChangeNotifier {
  bool darkMode = false;

  void setDarkMode(bool val) async {
    darkMode = val;
    Prefs.prefs.setBool("shore_darkMode", val);
    notifyListeners();
  }

  void onLoad() async {
    if (Prefs.prefs.containsKey("shore_darkMode")) {
      darkMode = Prefs.getBool("shore_darkMode");
    }
  }
}
