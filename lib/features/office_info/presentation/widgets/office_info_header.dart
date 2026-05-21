import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/office_info_entity.dart';
import '../cubit/office_info_cubit.dart';
import '../screens/upload_office_logo_screen.dart';

class OfficeInfoHeader extends StatelessWidget {
  final OfficeInfoEntity officeInfo;
  final bool isTablet;

  const OfficeInfoHeader({
    super.key,
    required this.officeInfo,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarSize = isTablet ? 100.0 : 80.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 28 : 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isTablet
          ? Row(
              children: [
                _buildLogo(context, avatarSize),
                const SizedBox(width: 24),
                Expanded(child: _buildNameSection(context, theme)),
              ],
            )
          : Column(
              children: [
                _buildLogo(context, avatarSize),
                const SizedBox(height: 12),
                _buildNameSection(context, theme),
              ],
            ),
    );
  }

  Widget _buildLogo(BuildContext context, double size) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: officeInfo.logoUrl != null
              ? ClipOval(
                  child: Image.network(
                    officeInfo.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _defaultIcon(context, size),
                  ),
                )
              : _defaultIcon(context, size),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {
              final cubit = context.read<OfficeInfoCubit>();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: cubit,
                    child: UploadOfficeLogoScreen(officeInfo: officeInfo),
                  ),
                ),
              );
              if (result == true && context.mounted) {
                cubit.refresh();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.cardColor, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                size: size * 0.2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _defaultIcon(BuildContext context, double size) {
    return Icon(
      Icons.business,
      color: Theme.of(context).colorScheme.primary,
      size: size * 0.45,
    );
  }

  Widget _buildNameSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: isTablet
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          officeInfo.name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: isTablet ? 22 : 18,
          ),
          textAlign: isTablet ? TextAlign.start : TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          officeInfo.email,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: isTablet ? 14 : 13,
          ),
          textAlign: isTablet ? TextAlign.start : TextAlign.center,
        ),
        const SizedBox(height: 10),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: officeInfo.isActive
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        officeInfo.isActive ? 'نشط' : 'غير نشط',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: officeInfo.isActive ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }
}
