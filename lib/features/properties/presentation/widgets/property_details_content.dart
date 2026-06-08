import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/price_formatter.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PropertyDetailsContent extends StatelessWidget {
  final PropertyDetailsEntity property;
  final bool isTablet;

  const PropertyDetailsContent({
    super.key,
    required this.property,
    this.isTablet = false,
  });

  String _formatPrice(String price) {
    return PriceFormatter.formatWithSeparators(price, locale: 'ar');
  }

  String _getCurrencySymbol() {
    return property.currency?.symbol ?? 'ريال';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final formatter = DateFormat('yyyy/MM/dd', 'ar');
      return formatter.format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final uri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Reference
          _buildTitleSection(context),
          const SizedBox(height: 16),

          // Price Section
          _buildPriceSection(context, isDark),
          const SizedBox(height: 24),

          // Property Info Cards
          _buildInfoCards(context, isDark),
          const SizedBox(height: 24),

          // Location Section
          _buildLocationSection(context, isDark),
          const SizedBox(height: 24),

          // Description Section
          _buildDescriptionSection(context, isDark),
          const SizedBox(height: 24),

          // Property Details
          _buildPropertyDetails(context, isDark),
          const SizedBox(height: 24),

          // Office Information
          _buildOfficeSection(context, isDark),
          const SizedBox(height: 24),

          // Contact Buttons
          _buildContactButtons(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              property.propertyType.icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                property.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'رقم المرجع: ${property.referenceNumber}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: property.status == 'available'
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                property.status == 'available' ? 'متاح' : 'غير متاح',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: property.status == 'available'
                      ? AppColors.success
                      : AppColors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_money, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              Text(
                property.offerType.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPrice(property.price),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  _getCurrencySymbol(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
          if (property.priceNegotiable) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'السعر قابل للتفاوض',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.visibility,
            label: 'المشاهدات',
            value: property.viewsCount.toString(),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.calendar_today,
            label: 'تاريخ النشر',
            value: _formatDate(property.publishedAt),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.darkDivider
              : AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkDivider
              : AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              Text(
                'الموقع',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLocationItem(
            context,
            icon: Icons.location_city,
            label: 'المحافظة',
            value: property.governorate.nameAr,
          ),
          const SizedBox(height: 12),
          _buildLocationItem(
            context,
            icon: Icons.map,
            label: 'المديرية',
            value: property.district.nameAr,
          ),
          const SizedBox(height: 12),
          _buildLocationItem(
            context,
            icon: Icons.place,
            label: 'الحي',
            value: property.neighborhood.nameAr,
          ),
          const SizedBox(height: 12),
          _buildLocationItem(
            context,
            icon: Icons.home,
            label: 'العنوان',
            value: property.address,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _launchUrl(
                  'https://www.google.com/maps/search/?api=1&query=${property.latitude},${property.longitude}',
                );
              },
              icon: Icon(
                Icons.map,
                color: isDark ? AppColors.darkText : AppColors.white,
              ),
              label: Text(
                'عرض على الخريطة',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkDivider
              : AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              Text(
                'الوصف',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            property.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetails(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkDivider
              : AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'تفاصيل العقار',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(context, 'نوع العقار', property.propertyType.name),
          const Divider(height: 24),
          _buildDetailRow(context, 'نوع العرض', property.offerType.name),
          const Divider(height: 24),
          _buildDetailRow(
            context,
            'الحالة',
            property.status == 'available' ? 'متاح' : 'غير متاح',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildOfficeSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkDivider
              : AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              Text(
                'معلومات المكتب',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildOfficeDetailRow(
            context,
            icon: Icons.business_center,
            label: 'اسم المكتب',
            value: property.office.name,
          ),
          const SizedBox(height: 12),
          _buildOfficeDetailRow(
            context,
            icon: Icons.email,
            label: 'البريد الإلكتروني',
            value: property.office.email,
          ),
          const SizedBox(height: 12),
          _buildOfficeDetailRow(
            context,
            icon: Icons.phone,
            label: 'رقم الهاتف',
            value: property.office.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall(property.office.phone),
            icon: const Icon(Icons.phone, color: AppColors.white),
            label: Text('اتصل الآن', style: TextStyle(color: AppColors.white)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _openWhatsApp(property.office.whatsappNumber),
            icon: const Icon(Icons.chat, color: AppColors.success),
            label: const Text('واتساب'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.success, width: 2),
              foregroundColor: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }
}
