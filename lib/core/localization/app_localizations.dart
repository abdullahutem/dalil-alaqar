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

      // nav
      'nav_home': 'Home',
      'nav_search': 'Search',
      'nav_properties': 'Properties',
      'nav_offices': 'Offices',
      'nav_profile': 'Profile',
      'nav_promotions': 'Promotions',
      'nav_dashboard': 'Dashboard',

      // Employee
      'add_employee': 'Add Employee',
      'name': 'Name',
      'enter_name': 'Enter name',
      'email': 'Email',
      'enter_email': 'Enter email',
      'password': 'Password',
      'enter_password': 'Enter password',
      'phone_number': 'Phone Number',
      'enter_phone': 'Enter phone number',
      'whatsapp_number': 'WhatsApp Number',
      'enter_whatsapp': 'Enter WhatsApp number',
      'address': 'Address',
      'enter_address': 'Enter address',
      'role': 'Role',
      'employee': 'Employee',
      'employees': 'Employees',
      'manager': 'Manager',
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

      // nav
      'nav_home': 'الرئيسية',
      'nav_search': 'البحث',
      'nav_properties': 'العقارات',
      'nav_offices': 'المكاتب',
      'nav_profile': 'الملف الشخصي',
      'nav_promotions': 'العروض',
      'nav_dashboard': 'لوحة التحكم',

      // Employee
      'employees': 'الموظفين',
      'add_employee': 'إضافة موظف',
      'name': 'الاسم',
      'enter_name': 'أدخل الاسم',
      'email': 'البريد الإلكتروني',
      'enter_email': 'أدخل البريد الإلكتروني',
      'password': 'كلمة المرور',
      'enter_password': 'أدخل كلمة المرور',
      'phone_number': 'رقم الهاتف',
      'enter_phone': 'أدخل رقم الهاتف',
      'whatsapp_number': 'رقم الواتساب',
      'enter_whatsapp': 'أدخل رقم الواتساب',
      'address': 'العنوان',
      'enter_address': 'أدخل العنوان',
      'role': 'الدور الوظيفي',
      'employee': 'موظف',
      'manager': 'مدير',
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
