import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/property_details_cubit.dart';
import 'property_details_mobile_layout.dart';
import 'property_details_tablet_layout.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final int propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PropertyDetailsCubit.create()..getPropertyDetails(propertyId),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return const PropertyDetailsTabletLayout();
            }
            return const PropertyDetailsMobileLayout();
          },
        ),
      ),
    );
  }
}
