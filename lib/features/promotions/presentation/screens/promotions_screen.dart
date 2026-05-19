import 'package:dalil_alaqar/features/promotions/presentation/cubit/promotions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'promotions_mobile_layout.dart';
import 'promotions_tablet_layout.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PromotionsCubit.create()..getPromotions(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('العروض الترويجية'),
          centerTitle: true,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return const PromotionsTabletLayout();
            }
            return const PromotionsMobileLayout();
          },
        ),
      ),
    );
  }
}
