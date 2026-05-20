import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';

class OfficeInfoSection extends StatelessWidget {
  final OfficeDetailsEntity officeDetails;

  const OfficeInfoSection({super.key, required this.officeDetails});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات المكتب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Commercial License
          _buildInfoRow(
            context,
            icon: Icons.badge,
            label: 'الرخصة التجارية',
            value: officeDetails.commercialLicense,
          ),

          if (officeDetails.licenseNumber != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.numbers,
              label: 'رقم الرخصة',
              value: officeDetails.licenseNumber!,
            ),
          ],

          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            icon: Icons.location_city,
            label: 'العنوان',
            value: officeDetails.address,
          ),

          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            icon: Icons.calendar_today,
            label: 'تاريخ الانضمام',
            value: _formatDate(officeDetails.createdAt),
          ),

          if (officeDetails.verificationDate != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.verified_user,
              label: 'تاريخ التوثيق',
              value: _formatDate(officeDetails.verificationDate!),
            ),
          ],

          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            icon: Icons.event,
            label: 'بداية الاشتراك',
            value: _formatDate(officeDetails.subscriptionStartDate),
          ),

          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            icon: Icons.event_available,
            label: 'نهاية الاشتراك',
            value: _formatDate(officeDetails.subscriptionEndDate),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
