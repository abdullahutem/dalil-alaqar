import 'package:flutter/material.dart';
import '../../domain/entities/office_info_entity.dart';

class OfficeInfoContactCard extends StatelessWidget {
  final OfficeInfoEntity officeInfo;

  const OfficeInfoContactCard({super.key, required this.officeInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات التواصل',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildRow(
            context,
            icon: Icons.phone_outlined,
            label: 'الهاتف',
            value: officeInfo.phone,
            theme: theme,
          ),
          if (officeInfo.whatsappNumber != null) ...[
            const SizedBox(height: 10),
            _buildRow(
              context,
              icon: Icons.chat_outlined,
              label: 'واتساب',
              value: officeInfo.whatsappNumber!,
              theme: theme,
            ),
          ],
          if (officeInfo.address != null) ...[
            const SizedBox(height: 10),
            _buildRow(
              context,
              icon: Icons.location_on_outlined,
              label: 'العنوان',
              value: officeInfo.address!,
              theme: theme,
            ),
          ],
          if (officeInfo.website != null) ...[
            const SizedBox(height: 10),
            _buildRow(
              context,
              icon: Icons.language_outlined,
              label: 'الموقع الإلكتروني',
              value: officeInfo.website!,
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: theme.textTheme.bodySmall?.color
                      ?.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
