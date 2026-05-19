import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isLoggedIn;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.isLoggedIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_rounded),
        label: localizations.translate('nav_home'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.apartment_rounded),
        label: localizations.translate('nav_properties'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.business_rounded),
        label: localizations.translate('nav_promotions'),
      ),
      // Only show dashboard for logged-in users
      if (isLoggedIn)
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_rounded),
          label: localizations.translate('nav_dashboard'),
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: items,
      ),
    );
  }
}
