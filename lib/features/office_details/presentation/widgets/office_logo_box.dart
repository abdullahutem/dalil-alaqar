import 'package:flutter/material.dart';

class OfficeLogoBox extends StatelessWidget {
  final String? logoUrl;
  final bool isDark;
  final Color border, muted;
  final double size;
  final double radius;

  const OfficeLogoBox({
    super.key,
    this.logoUrl,
    required this.isDark,
    required this.border,
    required this.muted,
    this.size = 62,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border, width: 0.5),
    ),
    child: logoUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(radius - 0.5),
            child: Image.network(
              logoUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, _) =>
                  Icon(Icons.business_rounded, size: size * 0.42, color: muted),
            ),
          )
        : Icon(Icons.business_rounded, size: size * 0.42, color: muted),
  );
}
