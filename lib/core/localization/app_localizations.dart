import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'app_name': 'Dalilak Real Estate',
      'app_slogan': 'Your Real Estate Guide',
      // Login
      'login_welcome': 'Welcome',
      'login_subtitle': 'Click to enter',
      'login_button': 'Login',
      'login_create_account': 'Create Account',
    },
    'ar': {
      // App
      'app_name': 'دليلك العقاري',
      'app_slogan': 'دليلك في عالم العقارات',

      // Login
      'login_welcome': 'مرحباً بكم',
      'login_subtitle': 'اضغط للدخول',
      'login_button': 'تسجيل الدخول',
      'login_create_account': 'إنشاء حساب',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
