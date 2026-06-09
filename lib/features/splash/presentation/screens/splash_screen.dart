import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:dalil_alaqar/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:dalil_alaqar/features/splash/presentation/cubit/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..startSplash(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCompletedAuthenticated) {
          // User is logged in or guest - go to main screen
          Navigator.of(context).pushReplacementNamed(AppRoutes.main);
        } else if (state is SplashCompletedUnauthenticated) {
          // User needs to login
          Navigator.of(context).pushReplacementNamed(AppRoutes.main);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset('assets/images/logo.png', fit: BoxFit.fill),
        ),
      ),
    );
  }
}
