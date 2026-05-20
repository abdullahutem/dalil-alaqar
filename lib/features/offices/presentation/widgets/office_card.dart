import 'package:dalil_alaqar/features/offices/domain/entities/office_entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OfficeCard extends StatelessWidget {
  final OfficeEntity office;
  final VoidCallback? onTap;

  const OfficeCard({super.key, required this.office, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildLogo(context),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                office.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (office.isVerified) ...[
                              const SizedBox(width: 6),
                              Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 18,
                              ),
                            ],
                          ],
                        ),
                        if (office.ownerName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            office.ownerName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (office.subscriptionType != null) ...[
                const SizedBox(height: 8),
                _buildSubscriptionBadge(context),
              ],
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _buildStatsRow(context),
              if (office.address != null) ...[
                const SizedBox(height: 10),
                _buildAddressRow(context),
              ],
              if (office.phone != null) ...[
                const SizedBox(height: 8),
                _buildContactRow(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: office.logo != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: office.logo!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    _buildLogoPlaceholder(context),
              ),
            )
          : _buildLogoPlaceholder(context),
    );
  }

  Widget _buildLogoPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Icon(Icons.business, color: theme.colorScheme.primary, size: 28),
    );
  }

  Widget _buildSubscriptionBadge(BuildContext context) {
    final theme = Theme.of(context);
    Color badgeColor;
    final subType = office.subscriptionType ?? '';

    if (subType.contains('ذهبية') || subType.contains('Gold')) {
      badgeColor = const Color(0xFFFFD700);
    } else if (subType.contains('VIP')) {
      badgeColor = const Color(0xFF9C27B0);
    } else if (subType.contains('فضية') || subType.contains('Silver')) {
      badgeColor = Colors.grey;
    } else {
      badgeColor = theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        subType,
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context,
          icon: Icons.star,
          iconColor: Colors.amber,
          label: office.rating?.toStringAsFixed(1) ?? '—',
          sublabel: '${office.totalRatings ?? 0} تقييم',
        ),
        _buildStatDivider(context),
        _buildStatItem(
          context,
          icon: Icons.home_work_outlined,
          iconColor: theme.colorScheme.primary,
          label: '${office.totalProperties ?? 0}',
          sublabel: 'عقار',
        ),
        _buildStatDivider(context),
        _buildStatItem(
          context,
          icon: Icons.remove_red_eye_outlined,
          iconColor: Colors.teal,
          label: _formatNumber(office.totalViews ?? 0),
          sublabel: 'مشاهدة',
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String sublabel,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          sublabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.3),
    );
  }

  Widget _buildAddressRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            office.address!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.phone_outlined, size: 16, color: Colors.green),
        const SizedBox(width: 6),
        Text(
          office.phone!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
          textDirection: TextDirection.ltr,
        ),
        if (office.whatsappNumber != null) ...[
          const SizedBox(width: 16),
          Icon(Icons.chat_outlined, size: 16, color: const Color(0xFF25D366)),
          const SizedBox(width: 4),
          Text(
            'واتساب',
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF25D366),
            ),
          ),
        ],
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
