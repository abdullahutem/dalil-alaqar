import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/localization/locale_cubit.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/add_employee_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/add_employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeesMobileLayout extends StatefulWidget {
  const AddEmployeesMobileLayout({super.key});

  @override
  State<AddEmployeesMobileLayout> createState() =>
      _AddEmployeesMobileLayoutState();
}

class _AddEmployeesMobileLayoutState extends State<AddEmployeesMobileLayout> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedRole = 'employee';
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AddEmployeeCubit>().addEmployee(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        whatsappNumber: _whatsappController.text.trim(),
        address: _addressController.text.trim(),
        role: _selectedRole,
      );
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isArabic = context.read<LocaleCubit>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AddEmployeeCubit, AddEmployeeState>(
      listener: (context, state) {
        if (state is AddEmployeeSuccess) {
          _showSnackBar(state.message);
          // Clear form
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _phoneController.clear();
          _whatsappController.clear();
          _addressController.clear();
          setState(() {
            _selectedRole = 'employee';
          });
          // Navigate back after a short delay
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          });
        } else if (state is AddEmployeeError) {
          _showSnackBar(state.message, isError: true);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Field
              _buildTextField(
                controller: _nameController,
                label: localizations.translate('name'),
                hint: localizations.translate('enter_name'),
                icon: Icons.person_outline,
                isDark: isDark,
                isArabic: isArabic,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال الاسم'
                        : 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              _buildTextField(
                controller: _emailController,
                label: localizations.translate('email'),
                hint: localizations.translate('enter_email'),
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                isDark: isDark,
                isArabic: isArabic,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال البريد الإلكتروني'
                        : 'Please enter email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return isArabic
                        ? 'الرجاء إدخال بريد إلكتروني صحيح'
                        : 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              _buildTextField(
                controller: _passwordController,
                label: localizations.translate('password'),
                hint: localizations.translate('enter_password'),
                icon: Icons.lock_outline,
                isDark: isDark,
                isArabic: isArabic,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: isDark ? AppColors.darkIcon : AppColors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال كلمة المرور'
                        : 'Please enter password';
                  }
                  if (value.length < 6) {
                    return isArabic
                        ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                        : 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              _buildTextField(
                controller: _phoneController,
                label: localizations.translate('phone_number'),
                hint: localizations.translate('enter_phone'),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                isDark: isDark,
                isArabic: isArabic,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال رقم الهاتف'
                        : 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // WhatsApp Number Field
              _buildTextField(
                controller: _whatsappController,
                label: localizations.translate('whatsapp_number'),
                hint: localizations.translate('enter_whatsapp'),
                icon: Icons.chat_outlined,
                keyboardType: TextInputType.phone,
                isDark: isDark,
                isArabic: isArabic,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال رقم الواتساب'
                        : 'Please enter WhatsApp number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address Field
              _buildTextField(
                controller: _addressController,
                label: localizations.translate('address'),
                hint: localizations.translate('enter_address'),
                icon: Icons.location_on_outlined,
                isDark: isDark,
                isArabic: isArabic,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال العنوان'
                        : 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Role Selection
              _buildRoleSelector(
                localizations: localizations,
                isArabic: isArabic,
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // Submit Button
              BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
                builder: (context, state) {
                  final isLoading = state is AddEmployeeLoading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            localizations.translate('add_employee'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    required bool isArabic,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            prefixIcon: Icon(
              icon,
              color: isDark ? AppColors.darkIcon : AppColors.grey,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector({
    required AppLocalizations localizations,
    required bool isArabic,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('role'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildRoleOption(
                  label: localizations.translate('employee'),
                  value: 'employee',
                  isDark: isDark,
                  isFirst: true,
                ),
              ),
              Expanded(
                child: _buildRoleOption(
                  label: localizations.translate('manager'),
                  value: 'manager',
                  isDark: isDark,
                  isLast: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleOption({
    required String label,
    required String value,
    required bool isDark,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = _selectedRole == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = value;
        });
      },
      borderRadius: BorderRadius.horizontal(
        left: isFirst ? const Radius.circular(12) : Radius.zero,
        right: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? const Radius.circular(12) : Radius.zero,
            right: isLast ? const Radius.circular(12) : Radius.zero,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkText : AppColors.lightText),
            ),
          ),
        ),
      ),
    );
  }
}
