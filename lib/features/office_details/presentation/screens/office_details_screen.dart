import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/office_details/presentation/cubit/office_details_cubit.dart';
import 'package:dalil_alaqar/features/office_details/presentation/cubit/office_details_state.dart';
import 'package:dalil_alaqar/features/office_details/presentation/screens/office_details_mobile_layout.dart';
import 'package:dalil_alaqar/features/office_details/presentation/screens/office_details_tablet_layout.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_details_loading.dart';

class OfficeDetailsScreen extends StatelessWidget {
  final int officeId;

  const OfficeDetailsScreen({super.key, required this.officeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OfficeDetailsCubit.create()..getOfficeDetails(officeId),
      child: const OfficeDetailsContent(),
    );
  }
}

class OfficeDetailsContent extends StatelessWidget {
  const OfficeDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OfficeDetailsCubit, OfficeDetailsState>(
        builder: (context, state) {
          if (state is OfficeDetailsLoading) {
            return const OfficeDetailsLoadingView();
          }

          if (state is OfficeDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('العودة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is OfficeDetailsSuccess) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 600) {
                  return OfficeDetailsTabletLayout(
                    officeDetails: state.officeDetails,
                  );
                } else {
                  return OfficeDetailsMobileLayout(
                    officeDetails: state.officeDetails,
                  );
                }
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
