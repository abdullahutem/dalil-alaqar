import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/splash/presentation/cubit/splash_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> startSplash() async {
    emit(SplashLoading());

    // Simulate splash delay
    await Future.delayed(const Duration(seconds: 2));

    // Check authentication status
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool('is_guest') ?? false;
    final token = prefs.getString('auth_token');

    if (isGuest || token != null) {
      // User is logged in or in guest mode - go to main
      emit(SplashCompletedAuthenticated());
    } else {
      // User needs to login
      emit(SplashCompletedUnauthenticated());
    }
  }
}
