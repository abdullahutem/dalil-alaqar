import 'package:flutter/material.dart';

class OfficeStarRow extends StatelessWidget {
  final double rating;
  final int count;
  final Color muted;

  const OfficeStarRow({
    super.key,
    required this.rating,
    required this.count,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    const amber = Color(0xFFEF9F27);
    return Row(
      children: [
        ...List.generate(5, (i) {
          if (i < rating.floor()) {
            return const Icon(Icons.star_rounded, size: 14, color: amber);
          } else if (i < rating && rating - i >= 0.5) {
            return const Icon(Icons.star_half_rounded, size: 14, color: amber);
          }
          return Icon(Icons.star_outline_rounded, size: 14, color: muted);
        }),
        const SizedBox(width: 5),
        Text(
          '${rating.toStringAsFixed(1)} ($count تقييم)',
          style: TextStyle(fontSize: 12, color: muted),
        ),
      ],
    );
  }
}
