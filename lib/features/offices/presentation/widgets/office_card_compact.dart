import 'package:dalil_alaqar/features/offices/domain/entities/office_entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OfficeCardCompact extends StatelessWidget {
  final OfficeEntity office;
  final VoidCallback? onTap;

  const OfficeCardCompact({super.key, required this.office, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(left: 12, bottom: 4),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildLogo(context),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                office.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (office.isVerified)
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 16,
                              ),
                          ],
                        ),
                        if (office.governorate != null)
                          Text(
                            office.governorate!.nameAr,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMiniStat(
                    context,
                    icon: Icons.star,
                    color: Colors.amber,
                    value: office.rating?.toStringAsFixed(1) ?? '—',
                  ),
                  _buildMiniStat(
                    context,
                    icon: Icons.home_work_outlined,
                    color: theme.colorScheme.primary,
                    value: '${office.totalProperties ?? 0} عقار',
                  ),
                  _buildMiniStat(
                    context,
                    icon: Icons.remove_red_eye_outlined,
                    color: Colors.teal,
                    value: _formatNumber(office.totalViews ?? 0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: office.logo != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: office.logo!,
                fit: BoxFit.cover,
                errorWidget: (_, __, _) => _placeholder(context),
              ),
            )
          : _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Icon(
      Icons.business,
      color: Theme.of(context).colorScheme.primary,
      size: 22,
    );
  }

  Widget _buildMiniStat(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 3),
        Text(
          value,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}
