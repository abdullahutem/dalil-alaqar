import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/property_details_entity.dart';
import '../cubit/property_details_cubit.dart';
import '../cubit/property_details_state.dart';
import '../widgets/property_image_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsMobileLayout extends StatelessWidget {
  const PropertyDetailsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
      builder: (context, state) {
        if (state is PropertyDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PropertyDetailsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('رجوع'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is PropertyDetailsSuccess) {
          return _PropertyView(property: state.property);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _PropertyView extends StatelessWidget {
  final PropertyDetailsEntity property;

  const _PropertyView({required this.property});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Image Gallery App Bar
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: PropertyImageGallery(
                  images: property.images,
                  baseUrl: EndPoints.kBaseImageUrl,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price Card
                  _buildTitleCard(context, theme, isDark),

                  // Quick Info
                  _buildQuickInfo(context, theme, isDark),

                  // Description
                  if (property.description != null &&
                      property.description!.isNotEmpty)
                    _buildDescriptionCard(context, theme, isDark),

                  // Location
                  _buildLocationCard(context, theme, isDark),

                  // Contact Actions
                  _buildContactCard(context, theme, isDark),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context, ThemeData theme, bool isDark) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badges
            Row(
              children: [
                _buildBadge(
                  property.offerType?.name ?? '',
                  const Color(0xFF1D9E75),
                  isDark,
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  property.propertyType?.name ?? '',
                  theme.colorScheme.primary,
                  isDark,
                ),
                const Spacer(),
                Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${property.viewsCount ?? 0}',
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              property.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Location
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    property.fullLocation,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _formatPrice(property.price ?? 0),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D9E75),
                  ),
                ),
                const SizedBox(width: 8),
                if (property.priceNegotiable)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'قابل للتفاوض',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(BuildContext context, ThemeData theme, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.tag_rounded,
              'الرقم المرجعي',
              property.referenceNumber ?? '',
              theme,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.home_work_outlined,
              'نوع العقار',
              property.propertyType?.name ?? '',
              theme,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.sell_outlined,
              'الحالة',
              _getStatusText(property.status ?? ''),
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'وصف العقار',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              property.description!,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'الموقع',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (property.hasCoordinates)
                  IconButton(
                    icon: const Icon(Icons.map_outlined),
                    onPressed: () => _openMap(
                      context,
                      property.latitude!,
                      property.longitude!,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (property.address != null && property.address!.isNotEmpty)
              _buildInfoRow(
                Icons.location_on_outlined,
                'العنوان',
                property.address!,
                theme,
              ),
            if (property.address != null && property.address!.isNotEmpty)
              const Divider(height: 24),
            _buildInfoRow(
              Icons.map_outlined,
              'المحافظة',
              property.governorate?.nameAr ?? '',
              theme,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.place_outlined,
              'المديرية',
              property.district?.nameAr ?? '',
              theme,
            ),
            if (property.neighborhood != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.near_me_outlined,
                'الحي',
                property.neighborhood!.nameAr,
                theme,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, ThemeData theme, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'للتواصل',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _launchUrl('tel:${property.referenceNumber}'),
                    icon: const Icon(Icons.phone),
                    label: const Text('اتصال'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl('https://wa.me/'),
                    icon: const Icon(Icons.chat),
                    label: const Text('واتساب'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.hintColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
      return '$s مليون ر.ي';
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

  String _getStatusText(String status) {
    switch (status) {
      case 'available':
        return 'متاح';
      case 'reserved':
        return 'محجوز';
      case 'sold':
        return 'مباع';
      case 'rented':
        return 'مؤجر';
      default:
        return status;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openMap(
    BuildContext context,
    String latitude,
    String longitude,
  ) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await _launchUrl(url);
  }
}
