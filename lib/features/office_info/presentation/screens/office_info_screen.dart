import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/office_info_cubit.dart';
import 'office_info_mobile_layout.dart';
import 'office_info_tablet_layout.dart';

class OfficeInfoScreen extends StatelessWidget {
  const OfficeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OfficeInfoCubit.create()..getOfficeInfo(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معلومات المكتب'),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return const OfficeInfoTabletLayout();
            }
            return const OfficeInfoMobileLayout();
          },
        ),
      ),
    );
  }
}
