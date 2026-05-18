import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';

class FeaturesSection extends StatelessWidget {
  final bool isTablet;

  const FeaturesSection({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final features = [
      {'icon': Icons.pool_rounded, 'key': 'feature_pool'},
      {'icon': Icons.fitness_center_rounded, 'key': 'feature_gym'},
      {'icon': Icons.restaurant_rounded, 'key': 'feature_restaurant'},
      {'icon': Icons.meeting_room_rounded, 'key': 'feature_halls'},
      {'icon': Icons.local_cafe_rounded, 'key': 'feature_cafe'},
      {'icon': Icons.spa_rounded, 'key': 'feature_spa'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.translate('features_title'),
            style: TextStyle(
              fontSize: isTablet ? 24 : 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            localizations.translate('features_subtitle'),
            style: TextStyle(
              fontSize: isTablet ? 14 : 11,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),
          isTablet
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    return _buildFeatureCard(
                      context,
                      features[index],
                      localizations,
                      isDark,
                      isTablet: true,
                    );
                  },
                )
              : SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemCount: features.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return _buildFeatureCard(
                        context,
                        features[index],
                        localizations,
                        isDark,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    Map<String, dynamic> feature,
    AppLocalizations localizations,
    bool isDark, {
    bool isTablet = false,
  }) {
    return Container(
      width: isTablet ? null : 140,
      padding: EdgeInsets.all(isTablet ? 20 : 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.3)
            : AppColors.white,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 16 : 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: AppColors.primary,
              size: isTablet ? 32 : 24,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              localizations.translate(feature['key'] as String),
              style: TextStyle(
                fontSize: isTablet ? 14 : 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
