import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';

class OfficeHeaderSection extends StatelessWidget {
  final OfficeDetailsEntity officeDetails;

  const OfficeHeaderSection({super.key, required this.officeDetails});

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
          // Office Name and Verification
          Row(
            children: [
              Expanded(
                child: Text(
                  officeDetails.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (officeDetails.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: Colors.blue, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'موثق',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Owner Name
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'المالك: ${officeDetails.ownerName}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Location
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${officeDetails.governorate.nameAr} - ${officeDetails.district.nameAr}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rating
          Row(
            children: [
              ...List.generate(5, (index) {
                final rating = double.tryParse(officeDetails.rating) ?? 0;
                if (index < rating.floor()) {
                  return const Icon(Icons.star, color: Colors.amber, size: 18);
                } else if (index < rating) {
                  return const Icon(
                    Icons.star_half,
                    color: Colors.amber,
                    size: 18,
                  );
                } else {
                  return Icon(
                    Icons.star_border,
                    color: Colors.grey[400],
                    size: 18,
                  );
                }
              }),
              const SizedBox(width: 8),
              Text(
                '${officeDetails.rating} (${officeDetails.totalRatings} تقييم)',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            officeDetails.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
