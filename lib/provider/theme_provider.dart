import 'package:flutter/material.dart';
import 'package:tienda/settings/styles_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _themeData;

  ThemeProvider(BuildContext context) {
    loadThemeData(context).then((_) {
      _themeData ??= StyleSettings.lightTheme(context);
    });
  }

  getthemeData() => _themeData;

  setthemeData(ThemeData theme, String themeName) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('theme', themeName);    
    _themeData = theme;
    notifyListeners();
  }

  Future<void> loadThemeData(BuildContext context) async {
    final _prefs = await SharedPreferences.getInstance();
    final themeString = _prefs.getString('theme');

    if (themeString != null) {
      if (themeString == "lightTheme") {
        _themeData = StyleSettings.lightTheme(context);
      } else if (themeString == "darkTheme") {
        _themeData = StyleSettings.darkTheme(context);
      } else if (themeString == "lightBlueTheme") {
        _themeData = StyleSettings.lightBlueTheme(context);
      } else if (themeString == "darkBlueTheme") {
        _themeData = StyleSettings.darkBlueTheme(context);
      }else if (themeString == "lightRedTheme") {
        _themeData = StyleSettings.lightRedTheme(context);
      }else if (themeString == "darkRedTheme") {
        _themeData = StyleSettings.darkRedTheme(context);
      }else if (themeString == "lightPurpleTheme") {
        _themeData = StyleSettings.lightPurpleTheme(context);
      }else if (themeString == "darkPurpleTheme") {
        _themeData = StyleSettings.darkPurpleTheme(context);
      }else if (themeString == "lightPinkTheme") {
        _themeData = StyleSettings.lightPinkTheme(context);
      }else if (themeString == "darkPinkTheme") {
        _themeData = StyleSettings.darkPinkTheme(context);
      }else if (themeString == "lightOrangeTheme") {
        _themeData = StyleSettings.lightOrangeTheme(context);
      }else if (themeString == "darkOrangeTheme") {
        _themeData = StyleSettings.darkOrangeTheme(context);
      }
    }
    notifyListeners();
  }
}
