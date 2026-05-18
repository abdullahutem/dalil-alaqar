import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_state.dart';
import 'package:dalil_alaqar/features/home/presentation/screens/home_screen.dart';
import 'package:dalil_alaqar/features/main/presentation/cubit/main_cubit.dart';
import 'package:dalil_alaqar/features/main/presentation/cubit/main_state.dart';
import 'package:dalil_alaqar/features/main/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Future<bool> _checkIsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_guest') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: FutureBuilder<bool>(
        future: _checkIsGuest(),
        builder: (context, snapshot) {
          final isGuest = snapshot.data ?? true;

          // Listen to AuthCubit to rebuild when auth status changes
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              // Determine if user is guest based on auth state
              bool currentIsGuest = isGuest;
              if (authState is AuthSuccess) {
                currentIsGuest = false;
              } else if (authState is AuthGuest) {
                currentIsGuest = true;
              }

              // Wrap with NotificationInitializer to handle push notifications
              return MainView(isGuest: currentIsGuest);
            },
          );
        },
      ),
    );
  }
}

class MainView extends StatelessWidget {
  final bool isGuest;

  const MainView({super.key, required this.isGuest});

  bool _isUserAdmin(AuthState authState) {
    if (authState is AuthSuccess) {
      final user = authState.authResponse.user;
      return user.roles.contains('admin') ||
          user.roles.contains('administrator');
    }
    return false;
  }

  Widget _getScreen(int index, bool isAdmin) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return HomeScreen();
      case 2:
        return HomeScreen();
      case 3:
        return HomeScreen();
      case 4:
        return HomeScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final isAdmin = _isUserAdmin(authState);

        return BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            // If user is not admin and currently on admin tab (index 4), redirect to home
            int currentIndex = state.currentIndex;
            if (!isAdmin && currentIndex >= 4) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<MainCubit>().changeTab(0);
              });
              currentIndex = 0;
            }

            return Scaffold(
              body: _getScreen(currentIndex, isAdmin),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<MainCubit>().changeTab(index);
                },
                showConversations: isAdmin,
              ),
            );
          },
        );
      },
    );
  }
}
