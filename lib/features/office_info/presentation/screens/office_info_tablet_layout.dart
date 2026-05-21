import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/office_info_cubit.dart';
import '../cubit/office_info_state.dart';
import '../widgets/office_info_contact_card.dart';
import '../widgets/office_info_description_card.dart';
import '../widgets/office_info_header.dart';
import '../widgets/office_info_skeleton.dart';
import '../widgets/office_info_social_card.dart';
import 'update_office_info_screen.dart';

class OfficeInfoTabletLayout extends StatelessWidget {
  const OfficeInfoTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfficeInfoCubit, OfficeInfoState>(
      builder: (context, state) {
        if (state is OfficeInfoLoading ||
            state is OfficeInfoUpdating ||
            state is OfficeLogoUploading) {
          return const OfficeInfoSkeleton(isTablet: true);
        }

        if (state is OfficeInfoError) {
          return _buildError(context, state.message);
        }

        if (state is OfficeInfoSuccess) {
          return RefreshIndicator(
            onRefresh: () => context.read<OfficeInfoCubit>().refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      OfficeInfoHeader(
                        officeInfo: state.officeInfo,
                        isTablet: true,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: OfficeInfoContactCard(
                              officeInfo: state.officeInfo,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: OfficeInfoSocialCard(
                              officeInfo: state.officeInfo,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OfficeInfoDescriptionCard(officeInfo: state.officeInfo),
                      const SizedBox(height: 24),
                      _buildEditButton(context, state.officeInfo),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEditButton(BuildContext context, officeInfo) {
    return SizedBox(
      width: double.infinity,
      child: Builder(
        builder: (builderContext) {
          return ElevatedButton.icon(
            onPressed: () async {
              final cubit = context.read<OfficeInfoCubit>();
              final result = await Navigator.push(
                builderContext,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: cubit,
                    child: UpdateOfficeInfoScreen(officeInfo: officeInfo),
                  ),
                ),
              );
              if (result == true && builderContext.mounted) {
                cubit.refresh();
              }
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text('تعديل معلومات المكتب'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<OfficeInfoCubit>().getOfficeInfo(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
