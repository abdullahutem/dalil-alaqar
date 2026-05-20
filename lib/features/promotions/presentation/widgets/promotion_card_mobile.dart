import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/promotions/domain/entities/promotion_entity.dart';
import 'package:flutter/material.dart';

class PromotionCardMobile extends StatelessWidget {
  final PromotionEntity promotion;
  final VoidCallback? onTap;

  const PromotionCardMobile({super.key, required this.promotion, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or Icon Header
              _buildImageHeader(context, isDark),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type Badge
                    _buildTypeBadge(
                      context,
                      isDark ? AppColors.darkDivider : AppColors.primary,
                    ),
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      promotion.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    if (promotion.description != null &&
                        promotion.description!.isNotEmpty) ...[
                      Text(
                        promotion.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.7,
                          ),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Discount Badge
                    _buildDiscountBadge(
                      context,
                      isDark ? AppColors.darkDivider : AppColors.primary,
                    ),
                    const SizedBox(height: 12),

                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Footer Info
                    _buildFooterInfo(context),

                    // Usage Progress
                    if (promotion.maxUsage != null) ...[
                      const SizedBox(height: 12),
                      _buildUsageProgress(
                        context,
                        isDark ? AppColors.darkDivider : AppColors.darkPrimary,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context, bool isDark) {
    if (promotion.image != null && promotion.image!.isNotEmpty) {
      return Stack(
        children: [
          CachedNetworkImage(
            imageUrl: promotion.image!,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => _buildIconHeader(context),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          // Status badge
          if (!promotion.isActive)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'غير نشط',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    }
    return _buildIconHeader(context);
  }

  Widget _buildIconHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: Opacity(
        opacity: 0.15,
        child: Image.asset("assets/images/logo.png", fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_typeIcon(promotion.type), color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            _typeLabel(promotion.type),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context, Color color) {
    final theme = Theme.of(context);
    String discountText;
    IconData icon;

    if (promotion.isPercentage && promotion.discountValue != null) {
      discountText = 'خصم ${promotion.discountValue!.toStringAsFixed(0)}%';
      icon = Icons.percent;
    } else if (promotion.isFixedAmount && promotion.discountValue != null) {
      discountText = 'خصم ${_formatCurrency(promotion.discountValue!)} د.ع';
      icon = Icons.attach_money;
    } else {
      discountText = 'ميزة مجانية';
      icon = Icons.card_giftcard;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(
            discountText,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (promotion.endDate != null) ...[
          Icon(Icons.access_time, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'ينتهي: ${_formatDate(promotion.endDate!)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ),
        ],
        if (promotion.usageCount > 0) ...[
          const SizedBox(width: 12),
          Icon(Icons.people_outline, size: 16, color: Colors.teal),
          const SizedBox(width: 4),
          Text(
            '${promotion.usageCount}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUsageProgress(BuildContext context, Color color) {
    final theme = Theme.of(context);
    final remaining = promotion.remainingUsage ?? 0;
    final progress = promotion.usagePercentage.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'متبقي: $remaining من ${promotion.maxUsage}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'percentage':
        return Icons.percent;
      case 'fixed_amount':
        return Icons.attach_money;
      case 'free_feature':
        return Icons.card_giftcard;
      default:
        return Icons.local_offer_outlined;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'percentage':
        return 'خصم نسبي';
      case 'fixed_amount':
        return 'خصم ثابت';
      case 'free_feature':
        return 'ميزة مجانية';
      default:
        return 'عرض';
    }
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000) {
      final thousands = value / 1000;
      if (thousands == thousands.truncateToDouble()) {
        return '${thousands.toInt()},000';
      }
      return '${thousands.toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }
}
