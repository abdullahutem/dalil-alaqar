import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficeContactSection extends StatelessWidget {
  final OfficeDetailsEntity officeDetails;

  const OfficeContactSection({super.key, required this.officeDetails});

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
            'معلومات الاتصال',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Phone
          _buildContactButton(
            context,
            icon: Icons.phone,
            label: 'الهاتف',
            value: officeDetails.phone,
            color: Colors.green,
            onTap: () => _launchUrl('tel:${officeDetails.phone}'),
          ),

          const SizedBox(height: 12),

          // Mobile Phone
          _buildContactButton(
            context,
            icon: Icons.smartphone,
            label: 'الجوال',
            value: officeDetails.mobilePhone,
            color: Colors.blue,
            onTap: () => _launchUrl('tel:${officeDetails.mobilePhone}'),
          ),

          const SizedBox(height: 12),

          // WhatsApp
          _buildContactButton(
            context,
            icon: Icons.chat,
            label: 'واتساب',
            value: officeDetails.whatsappNumber,
            color: const Color(0xFF25D366),
            onTap: () =>
                _launchUrl('https://wa.me/${officeDetails.whatsappNumber}'),
          ),

          const SizedBox(height: 12),

          // Email
          _buildContactButton(
            context,
            icon: Icons.email,
            label: 'البريد الإلكتروني',
            value: officeDetails.email,
            color: Colors.red,
            onTap: () => _launchUrl('mailto:${officeDetails.email}'),
          ),

          // Social Media
          if (officeDetails.website != null ||
              officeDetails.facebook != null ||
              officeDetails.instagram != null ||
              officeDetails.twitter != null) ...[
            const SizedBox(height: 20),
            Text(
              'وسائل التواصل الاجتماعي',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (officeDetails.website != null)
                  _buildSocialButton(
                    context,
                    icon: Icons.language,
                    color: Colors.blue,
                    onTap: () => _launchUrl(officeDetails.website!),
                  ),
                if (officeDetails.facebook != null)
                  _buildSocialButton(
                    context,
                    icon: Icons.facebook,
                    color: const Color(0xFF1877F2),
                    onTap: () => _launchUrl(officeDetails.facebook!),
                  ),
                if (officeDetails.instagram != null)
                  _buildSocialButton(
                    context,
                    icon: Icons.camera_alt,
                    color: const Color(0xFFE4405F),
                    onTap: () => _launchUrl(officeDetails.instagram!),
                  ),
                if (officeDetails.twitter != null)
                  _buildSocialButton(
                    context,
                    icon: Icons.flutter_dash,
                    color: const Color(0xFF1DA1F2),
                    onTap: () => _launchUrl(officeDetails.twitter!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 20),
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
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
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
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
