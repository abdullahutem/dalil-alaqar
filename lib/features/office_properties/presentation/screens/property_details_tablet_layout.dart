import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/core/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/property_details_entity.dart';
import '../cubit/property_details_cubit.dart';
import '../cubit/property_details_state.dart';
import '../widgets/property_image_gallery.dart';
import '../widgets/property_status_dropdown.dart';
import '../widgets/upload_property_images_widget.dart';
import '../widgets/edit_property_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsTabletLayout extends StatelessWidget {
  const PropertyDetailsTabletLayout({super.key});

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
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تفاصيل العقار'), centerTitle: true),
        floatingActionButton: EditPropertyButton(property: property),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Right side - Image and main info
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Gallery with Upload Button
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: 400,
                                child: PropertyImageGallery(
                                  images: property.images,
                                  baseUrl: EndPoints.kBaseImageUrl,
                                  propertyId: property.id,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showUploadImagesBottomSheet(context),
                                icon: const Icon(
                                  Icons.add_photo_alternate,
                                  size: 20,
                                ),
                                label: const Text('رفع صور'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Title & Badges
                        _buildTitleSection(context, theme),
                        const SizedBox(height: 24),

                        // Description
                        if (property.description != null &&
                            property.description!.isNotEmpty)
                          _buildDescriptionCard(context, theme),
                        const SizedBox(height: 24),

                        // Location
                        _buildLocationCard(context, theme),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Left side - Price and actions
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildPriceCard(context, theme),
                        const SizedBox(height: 16),
                        _buildQuickInfoCard(context, theme),
                        const SizedBox(height: 16),
                        _buildContactCard(context, theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildBadge(
              property.offerType?.name ?? '',
              const Color(0xFF1D9E75),
            ),
            const SizedBox(width: 8),
            _buildBadge(
              property.propertyType?.name ?? '',
              theme.colorScheme.primary,
            ),
            const Spacer(),
            Icon(Icons.visibility_outlined, size: 18, color: theme.hintColor),
            const SizedBox(width: 6),
            Text(
              '${property.viewsCount ?? 0} مشاهدة',
              style: TextStyle(fontSize: 14, color: theme.hintColor),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          property.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 18, color: theme.hintColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                property.fullLocation,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السعر',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${_formatPrice(property.price ?? 0)} ${_getCurrencySymbol()}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D9E75),
              ),
            ),
            if (property.priceNegotiable) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
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
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات سريعة',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
            _buildStatusRow(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.sell_outlined, size: 20, color: theme.hintColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الحالة',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 6),
              PropertyStatusDropdown(
                propertyId: property.id,
                currentStatus: property.status ?? 'available',
                compact: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'للتواصل',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchUrl('tel:${property.referenceNumber}'),
              icon: const Icon(Icons.phone),
              label: const Text('اتصال'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _launchUrl('https://wa.me/'),
              icon: const Icon(Icons.chat),
              label: const Text('واتساب'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 16),
            if (property.address != null && property.address!.isNotEmpty) ...[
              _buildInfoRow(
                Icons.location_on_outlined,
                'العنوان',
                property.address!,
                theme,
              ),
              const Divider(height: 24),
            ],
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

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
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
        Icon(icon, size: 22, color: theme.hintColor),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
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
    return PriceFormatter.formatCompact(price.toString(), showDecimals: true);
  }

  String _getCurrencySymbol() {
    return property.currency?.symbol ?? 'ريال';
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

  void _showUploadImagesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: UploadPropertyImagesWidget(
          propertyId: property.id,
          onUploadSuccess: () {
            // Refresh property details after successful upload
            context.read<PropertyDetailsCubit>().getPropertyDetails(
              property.id,
            );
          },
        ),
      ),
    );
  }
}
