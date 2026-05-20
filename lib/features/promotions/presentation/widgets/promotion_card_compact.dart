import 'package:dalil_alaqar/features/promotions/domain/entities/promotion_entity.dart';
import 'package:flutter/material.dart';

class PromotionCardCompact extends StatelessWidget {
  final PromotionEntity promotion;
  final VoidCallback? onTap;

  const PromotionCardCompact({super.key, required this.promotion, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _typeColor(promotion.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(left: 12, bottom: 4),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _typeIcon(promotion.type),
                          color: typeColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _typeLabel(promotion.type),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: typeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promotion.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildDiscountChip(context, typeColor),
                  if (promotion.endDate != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 12,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ينتهي ${_formatDate(promotion.endDate!)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountChip(BuildContext context, Color color) {
    String label;
    if (promotion.isPercentage && promotion.discountValue != null) {
      label = '${promotion.discountValue!.toStringAsFixed(0)}% خصم';
    } else if (promotion.isFixedAmount && promotion.discountValue != null) {
      label = '${_formatCurrency(promotion.discountValue!)} د.ع';
    } else {
      label = 'مجاناً';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
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
      return '${(value / 1000).toStringAsFixed(0)},000';
    }
    return value.toStringAsFixed(0);
  }
}
