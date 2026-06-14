import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/image_cache_config.dart';
import 'package:dalil_alaqar/features/offices/domain/entities/office_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OfficeCardCompact extends StatelessWidget {
  final OfficeEntity office;
  final VoidCallback? onTap;

  const OfficeCardCompact({super.key, required this.office, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image at the top
              AspectRatio(
                aspectRatio: 16 / 10,
                child: _LogoWidget(office: office, isDark: isDark),
              ),

              // Content below
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Office name
                    Text(
                      office.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                        letterSpacing: -0.2,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 3),

                    // Location
                    _buildLocation(isDark),

                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: isDark ? Colors.white12 : Colors.black12,
                      ),
                    ),

                    // Stats
                    _buildStats(context, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocation(bool isDark) {
    final locationText =
        office.governorate?.nameAr ?? office.district?.nameAr ?? office.address;

    if (locationText == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 13, color: Colors.grey[500]),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            locationText,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, bool isDark) {
    return Row(
      children: [
        _StatChip(
          icon: Icons.star_rounded,
          value: office.rating?.toStringAsFixed(1) ?? '—',
          chipColor: const Color(0xFFEFF6F6),
          chipColorDark: const Color(0xFF0D2424),
          contentColor: AppColors.primary,
          contentColorDark: AppColors.darkPrimary,
          isDark: isDark,
        ),
        const SizedBox(width: 6),
        _StatChip(
          icon: Icons.home_work_rounded,
          value: '${office.totalProperties ?? 0} عقار',
          chipColor: const Color(0xFFEFF6F6),
          chipColorDark: const Color(0xFF0D2424),
          contentColor: AppColors.primary,
          contentColorDark: AppColors.darkPrimary,
          isDark: isDark,
        ),
        const SizedBox(width: 6),
        _StatChip(
          icon: Icons.visibility_rounded,
          value: _formatNumber(office.totalViews ?? 0),
          chipColor: const Color(0xFFE6F4F4),
          chipColorDark: const Color(0xFF0A2020),
          contentColor: const Color(0xFF1B7A6E),
          contentColorDark: const Color(0xFF2EC4B6),
          isDark: isDark,
        ),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

// ─────────────────────────────────────────────
//  Logo widget (updated to full-width image)
// ─────────────────────────────────────────────
class _LogoWidget extends StatelessWidget {
  final OfficeEntity office;
  final bool isDark;
  const _LogoWidget({required this.office, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface
            : AppColors.primary.withValues(alpha: 0.06),
      ),
      child: office.logo != null
          ? CachedNetworkImage(
              imageUrl: "${EndPoints.kBaseImageUrl}${office.logo!}",
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  ImageCacheConfig.defaultPlaceholder(),
              errorWidget: (_, __, ___) =>
                  ImageCacheConfig.defaultPlaceholder(),
            )
          : ImageCacheConfig.defaultPlaceholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final bool isDark;
  const _Placeholder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.business_rounded,
        size: 48,
        color: isDark ? AppColors.darkPrimary : AppColors.primary,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Stat chip
// ─────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color chipColor;
  final Color chipColorDark;
  final Color contentColor;
  final Color contentColorDark;
  final bool isDark;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.chipColor,
    required this.chipColorDark,
    required this.contentColor,
    required this.contentColorDark,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? chipColorDark : chipColor;
    final fg = isDark ? contentColorDark : contentColor;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
