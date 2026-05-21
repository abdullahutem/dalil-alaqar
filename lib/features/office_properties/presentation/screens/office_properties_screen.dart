import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/office_properties_cubit.dart';
import 'office_properties_mobile_layout.dart';
import 'office_properties_tablet_layout.dart';

class OfficePropertiesScreen extends StatelessWidget {
  const OfficePropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OfficePropertiesCubit.create()..getOfficeProperties(),
      child: Scaffold(
        appBar: AppBar(title: const Text('عقارات المكتب'), centerTitle: true),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return const OfficePropertiesTabletLayout();
            }
            return const OfficePropertiesMobileLayout();
          },
        ),
      ),
    );
  }
}
