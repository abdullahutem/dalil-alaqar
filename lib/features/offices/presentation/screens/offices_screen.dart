import 'package:dalil_alaqar/features/offices/presentation/cubit/offices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'offices_mobile_layout.dart';
import 'offices_tablet_layout.dart';

class OfficesScreen extends StatelessWidget {
  const OfficesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OfficesCubit.create()..getOffices(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المكاتب العقارية'),
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return const OfficesTabletLayout();
            }
            return const OfficesMobileLayout();
          },
        ),
      ),
    );
  }
}
