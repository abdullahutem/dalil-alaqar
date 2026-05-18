import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showConversations;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showConversations = false,
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
        icon: const Icon(Icons.hotel_rounded),
        label: localizations.translate('nav_units'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.room_service_rounded),
        label: localizations.translate('nav_services'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.event_rounded),
        label: localizations.translate('nav_events'),
      ),

      if (showConversations)
        BottomNavigationBarItem(
          icon: const Icon(Icons.admin_panel_settings_rounded),
          label: localizations.translate('admin_control_title'),
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
