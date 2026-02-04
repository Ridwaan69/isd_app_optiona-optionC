// lib/language_provider.dart
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  // Changed default from 'en' to 'fr' (French)
  Locale _currentLocale = const Locale('fr', '');

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode, '');
    notifyListeners();
  }

  String get currentLanguageName {
    switch (_currentLocale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      default:
        return 'Français';
    }
  }
}