import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/dashboard/domain/entities/dashboard_stats_entity.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionInfo subscription;
  final LimitsInfo limits;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.limits,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.40)
        : Colors.black.withValues(alpha: 0.38);
    final secondary = isDark
        ? Colors.white.withValues(alpha: 0.62)
        : Colors.black.withValues(alpha: 0.55);
    final primary = isDark ? Colors.white : Colors.black;

    final usedRatio = limits.maxProperties > 0
        ? (limits.usedProperties / limits.maxProperties).clamp(0.0, 1.0)
        : 0.0;

    final isExpiringSoon = subscription.daysRemaining <= 7;
    final expiryColor = isExpiringSoon
        ? const Color(0xFFD4480A)
        : const Color(0xFF1D9E75);
    final expiryBg = isExpiringSoon
        ? (isDark ? const Color(0xFF2D1A0E) : const Color(0xFFFFF0E6))
        : (isDark ? const Color(0xFF1A3326) : const Color(0xFFEAF3DE));
    final expiryBorder = isExpiringSoon
        ? (isDark ? const Color(0xFF5A2E10) : const Color(0xFFFFCBA4))
        : (isDark ? const Color(0xFF2A5040) : const Color(0xFFC0DD97));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.planName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subscription.status,
                      style: TextStyle(fontSize: 12, color: secondary),
                    ),
                  ],
                ),
              ),
              // Days remaining badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: expiryBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: expiryBorder, width: 0.5),
                ),
                child: Text(
                  '${subscription.daysRemaining} يوم متبقٍ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: expiryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Usage row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'العقارات المستخدمة',
                style: TextStyle(fontSize: 12, color: muted),
              ),
              Text(
                '${limits.usedProperties} / ${limits.maxProperties}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usedRatio,
              minHeight: 6,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.07),
              valueColor: AlwaysStoppedAnimation<Color>(
                usedRatio > 0.85
                    ? const Color(0xFFD4480A)
                    : const Color(0xFF1D9E75),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Dates
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: border, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'النهاية',
                        style: TextStyle(fontSize: 10, color: muted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subscription.endDate,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
