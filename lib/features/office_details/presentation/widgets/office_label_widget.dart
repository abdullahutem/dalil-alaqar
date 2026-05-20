import 'package:flutter/material.dart';

class OfficeLabelWidget extends StatelessWidget {
  final String text;
  final Color muted;

  const OfficeLabelWidget({super.key, required this.text, required this.muted});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: muted,
      letterSpacing: 0.5,
    ),
  );
}
