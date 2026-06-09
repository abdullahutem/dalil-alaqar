import 'package:dalil_alaqar/features/office_properties/presentation/screens/office_update_property_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../property_types/presentation/cubit/property_types_cubit.dart';
import '../../../offer_types/presentation/cubit/offer_types_cubit.dart';
import '../../../governorates/presentation/cubit/governorates_cubit.dart';
import '../../domain/entities/property_details_entity.dart';
import '../cubit/property_details_cubit.dart';
import '../cubit/update_property_cubit.dart';

class EditPropertyButton extends StatelessWidget {
  final PropertyDetailsEntity property;

  const EditPropertyButton({super.key, required this.property});

  void _navigateToUpdateScreen(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UpdatePropertyCubit.create()),
            BlocProvider(create: (_) => PropertyTypesCubit.create()),
            BlocProvider(create: (_) => OfferTypesCubit.create()),
            BlocProvider(create: (_) => GovernoratesCubit.create()),
          ],
          child: OfficeUpdatePropertyScreen(property: property),
        ),
      ),
    );

    // If update was successful, refresh property details
    if (result == true && context.mounted) {
      context.read<PropertyDetailsCubit>().getPropertyDetails(property.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToUpdateScreen(context),
      icon: const Icon(Icons.edit),
      label: const Text('تعديل العقار'),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
