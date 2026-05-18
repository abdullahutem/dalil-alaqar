import 'package:dalil_alaqar/core/theme/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isDarkMode: true));

  void toggleTheme() {
    emit(ThemeState(isDarkMode: !state.isDarkMode));
  }

  void setDarkMode(bool isDark) {
    emit(ThemeState(isDarkMode: isDark));
  }
}
