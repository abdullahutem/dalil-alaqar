import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/promotion_entity.dart';

class PromotionCard extends StatelessWidget {
  final PromotionEntity promotion;
  final VoidCallback? onTap;

  const PromotionCard({
    super.key,
    required this.promotion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final typeColor = _typeColor(promotion.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bar with type color accent
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, typeColor),
                  const SizedBox(height: 12),
                  _buildDiscountBadge(context, typeColor),
                  const SizedBox(height: 10),
                  if (promotion.description != null) ...[
                    Text(
                      promotion.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _buildFooter(context, typeColor),
                  if (promotion.maxUsage != null) ...[
                    const SizedBox(height: 10),
                    _buildUsageProgress(context, typeColor),
                  ],
                  if (promotion.terms != null) ...[
                    const SizedBox(height: 10),
                    _buildTerms(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color typeColor) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (promotion.image != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: promotion.image!,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _iconPlaceholder(context, typeColor),
            ),
          ),
          const SizedBox(width: 12),
        ] else ...[
          _iconPlaceholder(context, typeColor),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                promotion.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              _buildTypeBadge(context, typeColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconPlaceholder(BuildContext context, Color color) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(_typeIcon(promotion.type), color: color, size: 26),
    );
  }

  Widget _buildTypeBadge(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _typeLabel(promotion.type),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context, Color color) {
    final theme = Theme.of(context);
    String discountText;

    if (promotion.isPercentage && promotion.discountValue != null) {
      discountText =
          'خصم ${promotion.discountValue!.toStringAsFixed(0)}%';
    } else if (promotion.isFixedAmount && promotion.discountValue != null) {
      discountText =
          'خصم ${_formatCurrency(promotion.discountValue!)} د.ع';
    } else {
      discountText = 'ميزة مجانية';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer_outlined, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            discountText,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, Color typeColor) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (promotion.endDate != null) ...[
          Icon(Icons.calendar_today_outlined,
              size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            'ينتهي: ${_formatDate(promotion.endDate!)}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
          const Spacer(),
        ],
        if (promotion.usageCount > 0) ...[
          Icon(Icons.people_outline, size: 14, color: Colors.teal),
          const SizedBox(width: 4),
          Text(
            '${promotion.usageCount} استخدام',
            style: theme.textTheme.labelSmall?.copyWith(color: Colors.teal),
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
              'الاستخدامات المتبقية: $remaining / ${promotion.maxUsage}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
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
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildTerms(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: 14, color: theme.textTheme.bodySmall?.color?.withOpacity(0.5)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              promotion.terms!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                fontStyle: FontStyle.italic,
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
        return const Color(0xFF2196F3); // Blue
      case 'fixed_amount':
        return const Color(0xFF4CAF50); // Green
      case 'free_feature':
        return const Color(0xFF9C27B0); // Purple
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
      return thousands.toStringAsFixed(1) + 'k';
    }
    return value.toStringAsFixed(0);
  }
}
