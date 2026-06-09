import 'package:dalil_alaqar/core/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../property_types/presentation/cubit/property_types_cubit.dart';
import '../../../offer_types/presentation/cubit/offer_types_cubit.dart';
import '../../../governorates/presentation/cubit/governorates_cubit.dart';
import '../../../districts/presentation/cubit/districts_cubit.dart';
import '../../../neighborhoods/presentation/cubit/neighborhoods_cubit.dart';
import '../../../currencies/presentation/cubit/currencies_cubit.dart';
import '../../domain/entities/office_property_entity.dart';
import '../cubit/office_properties_cubit.dart';
import '../cubit/office_properties_state.dart';
import '../cubit/update_property_cubit.dart';
import '../cubit/property_details_cubit.dart';
import '../cubit/property_details_state.dart';
import '../screens/office_property_details_screen.dart';
import '../screens/office_update_property_screen.dart';
import 'property_status_dropdown.dart';

class OfficePropertyCardTablet extends StatelessWidget {
  final OfficePropertyEntity property;

  const OfficePropertyCardTablet({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Container(
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
              padding: const EdgeInsets.all(14),
              child: _buildContent(context, theme),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertyDetailsScreen(propertyId: property.id),
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
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(context),
                  )
                : _imagePlaceholder(context),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  property.offerTypeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  PropertyStatusDropdown(
                    propertyId: property.id,
                    currentStatus: property.status,
                    compact: true,
                  ),
                  const SizedBox(width: 8),
                  _buildActionsMenu(context),
                ],
              ),
            ),
            // Image count badge
            if (property.images.length > 1)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.photo_library_outlined,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${property.images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return BlocBuilder<OfficePropertiesCubit, OfficePropertiesState>(
      buildWhen: (previous, current) {
        if (previous is OfficePropertiesSuccess &&
            current is OfficePropertiesSuccess) {
          return previous.deletingPropertyId != current.deletingPropertyId;
        }
        return false;
      },
      builder: (context, state) {
        final isDeleting =
            state is OfficePropertiesSuccess &&
            state.deletingPropertyId == property.id;

        return Material(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(8),
          child: isDeleting
              ? Container(
                  padding: const EdgeInsets.all(6),
                  child: const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  iconColor: Theme.of(context).textTheme.bodyMedium?.color,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'update') {
                      _navigateToUpdate(context);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'update',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          const Text('تعديل العقار'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'حذف العقار',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _navigateToUpdate(BuildContext context) async {
    // First, get the full property details
    final detailsCubit = PropertyDetailsCubit.create();

    // Show loading indicator
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Wait for property details to load
    await detailsCubit.getPropertyDetails(property.id);

    // Close loading indicator
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    final detailsState = detailsCubit.state;
    if (detailsState is! PropertyDetailsSuccess) {
      if (context.mounted) {
        final errorMsg = detailsState is PropertyDetailsError
            ? detailsState.message
            : 'فشل في تحميل تفاصيل العقار';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
      detailsCubit.close();
      return;
    }

    // Get property details
    final propertyDetails = detailsState.property;

    if (!context.mounted) {
      detailsCubit.close();
      return;
    }

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UpdatePropertyCubit.create()),
            BlocProvider(create: (_) => PropertyTypesCubit.create()),
            BlocProvider(create: (_) => OfferTypesCubit.create()),
            BlocProvider(create: (_) => GovernoratesCubit.create()),
            BlocProvider(create: (_) => DistrictsCubit.create()),
            BlocProvider(create: (_) => NeighborhoodsCubit.create()),
            BlocProvider(create: (_) => CurrenciesCubit.create()),
          ],
          child: OfficeUpdatePropertyScreen(property: propertyDetails),
        ),
      ),
    );

    detailsCubit.close();

    // Refresh the list if update was successful
    if (result == true && context.mounted) {
      context.read<OfficePropertiesCubit>().getOfficeProperties(refresh: true);
    }
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

  Widget _imagePlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(
          Icons.home_outlined,
          size: 48,
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          icon: Icons.category_outlined,
          value: property.propertyTypeName,
          theme: theme,
        ),
        const SizedBox(height: 4),
        _buildInfoRow(
          context,
          icon: Icons.location_on_outlined,
          value:
              '${property.neighborhoodName != null ? '${property.neighborhoodName}، ' : ''}${property.districtName}، ${property.governorateName}',
          theme: theme,
        ),
        const SizedBox(height: 10),
        const Divider(height: 1),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatPrice(property.price)} ${_getCurrencySymbol()}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (property.priceNegotiable)
                  Text(
                    'قابل للتفاوض',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 14,
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${property.viewsCount}',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
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
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return PriceFormatter.formatCompact(price.toString(), showDecimals: true);
  }

  String _getCurrencySymbol() {
    return property.currency?.symbol ?? 'ريال';
  }
}
