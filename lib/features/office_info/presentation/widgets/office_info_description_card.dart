import 'package:flutter/material.dart';
import '../../domain/entities/office_info_entity.dart';

class OfficeInfoDescriptionCard extends StatelessWidget {
  final OfficeInfoEntity officeInfo;

  const OfficeInfoDescriptionCard({super.key, required this.officeInfo});

  @override
  Widget build(BuildContext context) {
    if (officeInfo.description == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نبذة عن المكتب',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Text(
            officeInfo.description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
