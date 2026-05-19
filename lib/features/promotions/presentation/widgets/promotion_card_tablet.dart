import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalil_alaqar/features/promotions/domain/entities/promotion_entity.dart';
import 'package:flutter/material.dart';

class PromotionCardTablet extends StatelessWidget {
  final PromotionEntity promotion;
  final VoidCallback? onTap;

  const PromotionCardTablet({super.key, required this.promotion, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final typeColor = _typeColor(promotion.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section (Left)
              _buildImageSection(context, typeColor, isDark),

              // Content Section (Right)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          _buildTypeBadge(context, typeColor),
                          const Spacer(),
                          if (!promotion.isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.3),
                                ),
                              ),
                              child: const Text(
                                'غير نشط',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        promotion.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Description
                      if (promotion.description != null &&
                          promotion.description!.isNotEmpty) ...[
                        Text(
                          promotion.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.7,
                            ),
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Discount Badge
                      _buildDiscountBadge(context, typeColor),
                      const SizedBox(height: 16),

                      // Usage Progress
                      if (promotion.maxUsage != null) ...[
                        _buildUsageProgress(context, typeColor),
                        const SizedBox(height: 16),
                      ],

                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Footer Info
                      _buildFooterInfo(context, typeColor),

                      // Terms
                      if (promotion.terms != null &&
                          promotion.terms!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildTerms(context),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    Color typeColor,
    bool isDark,
  ) {
    if (promotion.image != null && promotion.image!.isNotEmpty) {
      return SizedBox(
        width: 280,
        child: CachedNetworkImage(
          imageUrl: promotion.image!,
          height: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _buildIconSection(context, typeColor),
        ),
      );
    }
    return _buildIconSection(context, typeColor);
  }

  Widget _buildIconSection(BuildContext context, Color typeColor) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            typeColor.withValues(alpha: 0.2),
            typeColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(_typeIcon(promotion.type), color: typeColor, size: 64),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_typeIcon(promotion.type), color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            _typeLabel(promotion.type),
            style: TextStyle(
              color: color,
              fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(
            discountText,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
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
              'الاستخدامات المتبقية: $remaining من ${promotion.maxUsage}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterInfo(BuildContext context, Color typeColor) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        if (promotion.endDate != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'ينتهي: ${_formatDate(promotion.endDate!)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        if (promotion.usageCount > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, size: 18, color: Colors.teal),
              const SizedBox(width: 8),
              Text(
                '${promotion.usageCount} استخدام',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        if (promotion.startDate != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'يبدأ: ${_formatDate(promotion.startDate!)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                  fontSize: 13,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTerms(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              promotion.terms!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'percentage':
        return const Color(0xFF2196F3);
      case 'fixed_amount':
        return const Color(0xFF4CAF50);
      case 'free_feature':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF607D8B);
    }
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
