import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/office_properties_cubit.dart';
import '../cubit/property_details_cubit.dart';
import 'office_property_details_mobile_layout.dart';
import 'office_property_details_tablet_layout.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final int propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              PropertyDetailsCubit.create()..getPropertyDetails(propertyId),
        ),
        BlocProvider(create: (_) => OfficePropertiesCubit.create()),
      ],
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return const OfficePropertyDetailsTabletLayout();
            }
            return const OfficePropertyDetailsMobileLayout();
          },
        ),
      ),
    );
  }
}
