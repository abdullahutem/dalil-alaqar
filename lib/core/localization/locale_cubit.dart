import 'package:dalil_alaqar/core/localization/locale_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(locale: Locale('ar', 'SA')));

  void changeLocale(String languageCode) {
    final newLocale = languageCode == 'ar'
        ? const Locale('ar', 'SA')
        : const Locale('en', 'US');
    emit(LocaleState(locale: newLocale));
  }

  void toggleLocale() {
    final newLocale = state.locale.languageCode == 'ar'
        ? const Locale('en', 'US')
        : const Locale('ar', 'SA');
    emit(LocaleState(locale: newLocale));
  }

  bool get isArabic => state.locale.languageCode == 'ar';
  bool get isEnglish => state.locale.languageCode == 'en';
}
