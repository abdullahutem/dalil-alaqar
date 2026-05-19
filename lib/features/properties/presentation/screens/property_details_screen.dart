import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/property_details_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/property_details_mobile_layout.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/property_details_tablet_layout.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final int propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PropertyDetailsCubit.create()..getPropertyDetails(id: propertyId),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return const PropertyDetailsTabletLayout();
            } else {
              return const PropertyDetailsMobileLayout();
            }
          },
        ),
      ),
    );
  }
}
