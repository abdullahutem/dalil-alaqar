import 'package:flutter/material.dart';

class OfficeVerticalDivider extends StatelessWidget {
  final Color color;

  const OfficeVerticalDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36,
    child: VerticalDivider(color: color, width: 1, thickness: 0.5),
  );
}
