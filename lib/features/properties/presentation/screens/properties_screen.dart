import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/properties_mobile_layout.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/properties_tablet_layout.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العقارات'), centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return const PropertiesTabletLayout();
          } else {
            return const PropertiesMobileLayout();
          }
        },
      ),
    );
  }
}
