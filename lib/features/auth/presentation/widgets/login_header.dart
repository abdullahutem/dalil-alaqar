import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/responsive.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Logo
        Container(
          width: Responsive.isMobile(context) ? 200 : 240,
          height: Responsive.isMobile(context) ? 200 : 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.3),
                AppColors.primaryDark.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.hotel_rounded,
              size: Responsive.isMobile(context) ? 100 : 120,
              color: AppColors.primary,
            ),
          ),
        ),

        SizedBox(height: Responsive.scaledHeight(context, 3)),

        // Welcome Text
        Text(
          localizations.translate('login_welcome'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),

        SizedBox(height: Responsive.scaledHeight(context, 1)),

        // App Name
        Text(
          localizations.translate('app_name'),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: Responsive.scaledHeight(context, 0.5)),

        // Subtitle
        Text(
          localizations.translate('login_subtitle'),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
