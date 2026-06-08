import 'package:flutter/material.dart';

class OfficeInfoCard extends StatelessWidget {
  final Widget child;
  final Color surface, border;
  final EdgeInsets margin, padding;

  const OfficeInfoCard({
    super.key,
    required this.child,
    required this.surface,
    required this.border,
    required this.margin,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: margin,
    decoration: BoxDecoration(
      color: surface,
      border: Border(
        top: BorderSide(color: border, width: 0.5),
        bottom: BorderSide(color: border, width: 0.5),
      ),
    ),
    padding: padding,
    child: child,
  );
}
