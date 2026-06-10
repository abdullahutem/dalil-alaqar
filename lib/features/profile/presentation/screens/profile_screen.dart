import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/end_points.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_header_skeleton.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit.create()..getProfile(),
      child: const ProfileScreenContent(),
    );
  }
}

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darkIcon : AppColors.white,
        ),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: isDark ? AppColors.darkIcon : AppColors.white,
                  ),
                  onPressed: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ProfileCubit>(),
                          child: EditProfileScreen(
                            initialName: state.profile.user.name,
                            initialPhone: state.profile.user.phoneNumber,
                            initialWhatsApp: state.profile.user.whatsappNumber,
                          ),
                        ),
                      ),
                    );
                    // Refresh if profile was updated
                    if (result == true && context.mounted) {
                      context.read<ProfileCubit>().getProfile();
                    }
                  },
                  tooltip: 'تعديل الملف الشخصي',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeaderSkeleton(),
                  SizedBox(height: 16),
                  // Additional skeleton items could go here
                ],
              ),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<ProfileCubit>().getProfile(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;
            final user = profile.user;
            final office = profile.office;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark ? AppColors.darkBackground : AppColors.primary,
                          isDark ? AppColors.darkBackground : AppColors.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        if (office.logo != null)
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${EndPoints.kBaseImageUrl}${office.logo}',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                    strokeWidth: 2,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.business,
                                  size: 60,
                                  color: isDark
                                      ? AppColors.darkBackground
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          )
                        else
                          const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.business,
                              size: 60,
                              color: Colors.blue,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.role == 'owner' ? 'مالك' : user.role,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Info Cards
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // User Info Card
                        _buildInfoCard(
                          context: context,
                          title: 'معلومات المستخدم',
                          icon: Icons.person,
                          isDark: isDark,
                          children: [
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              label: 'البريد الإلكتروني',
                              value: user.email,
                              isDark: isDark,
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              icon: Icons.phone_outlined,
                              label: 'رقم الهاتف',
                              value: user.phoneNumber,
                              isDark: isDark,
                            ),
                            if (user.whatsappNumber != null) ...[
                              const Divider(height: 24),
                              _buildInfoRow(
                                icon: Icons.chat_outlined,
                                label: 'رقم الواتساب',
                                value: user.whatsappNumber!,
                                isDark: isDark,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Office Info Card
                        _buildInfoCard(
                          context: context,
                          title: 'معلومات المكتب',
                          icon: Icons.business,
                          isDark: isDark,
                          children: [
                            _buildInfoRow(
                              icon: Icons.business_outlined,
                              label: 'اسم المكتب',
                              value: office.name,
                              isDark: isDark,
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              label: 'البريد الإلكتروني',
                              value: office.email,
                              isDark: isDark,
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              icon: Icons.phone_outlined,
                              label: 'رقم الهاتف',
                              value: office.mobilePhone,
                              isDark: isDark,
                            ),
                            if (office.subscriptionType != null) ...[
                              const Divider(height: 24),
                              _buildInfoRow(
                                icon: Icons.card_membership_outlined,
                                label: 'نوع الاشتراك',
                                value: office.subscriptionType!,
                                isDark: isDark,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('لا توجد بيانات'));
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Card(
      elevation: isDark ? 2 : 1,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
