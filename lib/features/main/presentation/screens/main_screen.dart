import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_state.dart';
import 'package:dalil_alaqar/features/home/presentation/screens/home_screen.dart';
import 'package:dalil_alaqar/features/main/presentation/cubit/main_cubit.dart';
import 'package:dalil_alaqar/features/main/presentation/cubit/main_state.dart';
import 'package:dalil_alaqar/features/main/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:dalil_alaqar/features/promotions/presentation/screens/promotions_screen.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/properties_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            int currentIndex = state.currentIndex;

            return Scaffold(
              body: IndexedStack(
                index: currentIndex,
                children: [
                  HomeScreen(),
                  const PropertiesScreen(),
                  const PromotionsScreen(),
                  _PlaceholderScreen(title: 'Profile'),
                ],
              ),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<MainCubit>().changeTab(index);
                },
              ),
            );
          },
        );
      },
    );
  }
}

// Placeholder screen for features not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '$title - Coming Soon',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
