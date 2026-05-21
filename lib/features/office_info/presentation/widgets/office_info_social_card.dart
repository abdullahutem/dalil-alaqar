import 'package:flutter/material.dart';
import '../../domain/entities/office_info_entity.dart';

class OfficeInfoSocialCard extends StatelessWidget {
  final OfficeInfoEntity officeInfo;

  const OfficeInfoSocialCard({super.key, required this.officeInfo});

  bool get _hasSocial =>
      officeInfo.facebook != null ||
      officeInfo.instagram != null ||
      officeInfo.twitter != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasSocial) return const SizedBox.shrink();

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
            'التواصل الاجتماعي',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),
          if (officeInfo.facebook != null) ...[
            _buildSocialRow(
              context,
              icon: Icons.facebook,
              label: 'فيسبوك',
              value: officeInfo.facebook!,
              color: const Color(0xFF1877F2),
              theme: theme,
            ),
          ],
          if (officeInfo.instagram != null) ...[
            if (officeInfo.facebook != null) const SizedBox(height: 10),
            _buildSocialRow(
              context,
              icon: Icons.camera_alt_outlined,
              label: 'انستغرام',
              value: officeInfo.instagram!,
              color: const Color(0xFFE1306C),
              theme: theme,
            ),
          ],
          if (officeInfo.twitter != null) ...[
            if (officeInfo.facebook != null || officeInfo.instagram != null)
              const SizedBox(height: 10),
            _buildSocialRow(
              context,
              icon: Icons.close,
              label: 'تويتر / X',
              value: officeInfo.twitter!,
              color: Colors.black,
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSocialRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: color),
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
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontSize: 14, color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
