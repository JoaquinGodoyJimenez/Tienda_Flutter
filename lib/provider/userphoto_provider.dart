import 'package:flutter/material.dart';

class UserPhotoProvider extends ChangeNotifier {
  String _imageUrl = 'https://firebasestorage.googleapis.com/v0/b/mrjc-tienda.appspot.com/o/assets%2Fdefault_image.png?alt=media&token=32836d48-26bc-4a7b-9278-d7d020d47f3a';

  String get imageUrl => _imageUrl;

  set imageUrl(String newImageUrl) {
    _imageUrl = newImageUrl;
    notifyListeners(); // Notificar a los widgets interesados del cambio de estado
  }
}