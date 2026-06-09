import 'package:dalil_alaqar/core/theme/app_colors.dart';
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

class OfficeInfoMobileLayout extends StatelessWidget {
  const OfficeInfoMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfficeInfoCubit, OfficeInfoState>(
      builder: (context, state) {
        if (state is OfficeInfoLoading ||
            state is OfficeInfoUpdating ||
            state is OfficeLogoUploading) {
          return const OfficeInfoSkeleton();
        }

        if (state is OfficeInfoError) {
          return _buildError(context, state.message);
        }

        if (state is OfficeInfoSuccess) {
          return RefreshIndicator(
            onRefresh: () => context.read<OfficeInfoCubit>().refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  OfficeInfoHeader(officeInfo: state.officeInfo),
                  const SizedBox(height: 16),
                  OfficeInfoContactCard(officeInfo: state.officeInfo),
                  const SizedBox(height: 16),
                  OfficeInfoSocialCard(officeInfo: state.officeInfo),
                  if (state.officeInfo.facebook != null ||
                      state.officeInfo.instagram != null ||
                      state.officeInfo.twitter != null)
                    const SizedBox(height: 16),
                  OfficeInfoDescriptionCard(officeInfo: state.officeInfo),
                  const SizedBox(height: 24),
                  _buildEditButton(context, state.officeInfo),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEditButton(BuildContext context, officeInfo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            icon: Icon(Icons.edit_outlined),
            label: Text(
              'تعديل معلومات المكتب',
              style: TextStyle(
                color: isDark ? AppColors.darkText : AppColors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.darkDivider
                  : AppColors.primary,
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
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
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
