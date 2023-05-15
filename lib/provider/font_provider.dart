import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider extends ChangeNotifier {
  static const String _selectedFontKey = 'selected_font';
  static const String _defaultFont = 'Default';

  String _selectedFontFamily = _defaultFont;

  FontProvider() {
    _loadSelectedFontFamily();
  }

  String get selectedFontFamily => _selectedFontFamily;

  set selectedFontFamily(String fontFamily) {
    if (fontFamily != _selectedFontFamily) {
      _selectedFontFamily = fontFamily;
      _saveSelectedFontFamily();
      notifyListeners();
    }
  }

  void _loadSelectedFontFamily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loadedFontFamily = prefs.getString(_selectedFontKey);
    if (loadedFontFamily != null) {
      _selectedFontFamily = loadedFontFamily;
    }
    notifyListeners();
  }

  void _saveSelectedFontFamily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedFontKey, _selectedFontFamily);
  }
}
