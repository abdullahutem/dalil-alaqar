import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/localization/locale_cubit.dart';
import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/theme/theme_cubit.dart';
import 'package:dalil_alaqar/core/utils/breakpoints.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_state.dart';
import 'package:dalil_alaqar/features/home/presentation/screens/home_mobile_layout.dart';
import 'package:dalil_alaqar/features/home/presentation/screens/home_tablet_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isRTL = context.read<LocaleCubit>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,

        title: Text(localizations.translate('app_name')),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: isDark ? AppColors.darkText : AppColors.white,
              size: 22,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            tooltip: 'Theme',
          ),

          // Only show logout button if user is logged in
          const SizedBox(width: 8),
        ],
        leading: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return IconButton(
                icon: Icon(
                  Icons.logout_rounded,
                  color: isDark ? AppColors.darkText : AppColors.white,
                  size: 22,
                ),
                onPressed: () => _showLogoutDialog(context, localizations),
                tooltip: localizations.translate('logout'),
              );
            }
            return IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.login);
              },
              icon: Icon(Icons.login),
            );
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (Breakpoints.isMobile(constraints.maxWidth)) {
            return const HomeMobileLayout();
          } else {
            return const HomeTabletLayout();
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations localizations) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        title: Text(
          localizations.translate('logout'),
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          localizations.translate('logout_confirmation'),
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              localizations.translate('cancel'),
              style: TextStyle(
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthCubit>().logout();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
            child: Text(
              localizations.translate('logout'),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
