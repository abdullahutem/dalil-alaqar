import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/offer_types/domain/entities/offer_type_entity.dart';

class OfferTypeFilterChip extends StatelessWidget {
  final OfferTypeEntity offerType;
  final bool isSelected;
  final VoidCallback onTap;

  const OfferTypeFilterChip({
    super.key,
    required this.offerType,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIconForOfferType(String name) {
    if (name.contains('للبيع')) {
      return Icons.sell_outlined;
    } else if (name.contains('للإيجار')) {
      return Icons.key_outlined;
    } else if (name.contains('للاستثمار')) {
      return Icons.trending_up_outlined;
    }
    return Icons.home_work_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForOfferType(offerType.name),
              size: 18,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              offerType.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
