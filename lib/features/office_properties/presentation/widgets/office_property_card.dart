import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalil_alaqar/core/utils/image_cache_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/office_property_entity.dart';
import '../cubit/office_properties_cubit.dart';
import 'property_status_badge.dart';

class OfficePropertyCard extends StatelessWidget {
  final OfficePropertyEntity property;

  const OfficePropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
          _buildImage(context),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildContent(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final imageUrl = property.primaryImageUrl;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  ImageCacheConfig.defaultPlaceholder(),
              errorWidget: (_, __, ___) =>
                  ImageCacheConfig.defaultPlaceholder(),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  property.offerTypeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Row(
                children: [
                  PropertyStatusBadge(status: property.status),
                  const SizedBox(width: 8),
                  _buildDeleteButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => _showDeleteConfirmation(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف العقار "${property.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final cubit = context.read<OfficePropertiesCubit>();
      final success = await cubit.deleteProperty(property.id);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف العقار بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.category_outlined,
              size: 13,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Text(
              property.propertyTypeName,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.location_on_outlined,
              size: 13,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${property.districtName}، ${property.governorateName}',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatPrice(property.price),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                if (property.priceNegotiable)
                  Text(
                    'قابل للتفاوض',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 13,
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${property.viewsCount}',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          property.referenceNumber,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      final m = price / 1000000;
      final s = m == m.truncateToDouble()
          ? '${m.toInt()}'
          : m.toStringAsFixed(1);
      return '$s م ر.ي';
    }
    if (price >= 1000) {
      final k = price / 1000;
      final s = k == k.truncateToDouble()
          ? '${k.toInt()}'
          : k.toStringAsFixed(1);
      return '$s ألف ر.ي';
    }
    return '${price.toInt()} ر.ي';
  }
}
