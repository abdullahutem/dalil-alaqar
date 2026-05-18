import 'package:dalil_alaqar/features/advertisements/presentation/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/home/presentation/widgets/features_section.dart';

class HomeTabletLayout extends StatelessWidget {
  const HomeTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              // Slider Section
              SliderWidget(isTablet: true),

              SizedBox(height: 40),

              // // Reviews Section
              // ReviewsSection(isTablet: true),
              // SizedBox(height: 40),

              // // Branches Section
              // BranchesSection(),
              // SizedBox(height: 40),

              // Features Section
              FeaturesSection(isTablet: true),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
