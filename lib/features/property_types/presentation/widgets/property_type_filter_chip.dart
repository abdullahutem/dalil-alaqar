import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/property_types/domain/entities/property_type_entity.dart';

class PropertyTypeFilterChip extends StatelessWidget {
  final PropertyTypeEntity propertyType;
  final bool isSelected;
  final VoidCallback onTap;

  const PropertyTypeFilterChip({
    super.key,
    required this.propertyType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(propertyType.icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              propertyType.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
