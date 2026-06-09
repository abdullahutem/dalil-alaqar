import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/localization/locale_cubit.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/employee/domain/entities/employee_entity.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/add_employee_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/add_employee_state.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/update_employee_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/update_employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeesTabletLayout extends StatefulWidget {
  final EmployeeEntity? employee;

  const AddEmployeesTabletLayout({super.key, this.employee});

  @override
  State<AddEmployeesTabletLayout> createState() =>
      _AddEmployeesTabletLayoutState();
}

class _AddEmployeesTabletLayoutState extends State<AddEmployeesTabletLayout> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  late final TextEditingController _phoneController;
  late final TextEditingController _whatsappController;
  final _addressController = TextEditingController();

  late String _selectedRole;
  late String _selectedUserType;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with employee data if editing
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _emailController = TextEditingController(
      text: widget.employee?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.employee?.phoneNumber ?? '',
    );
    _whatsappController = TextEditingController(
      text: widget.employee?.whatsappNumber ?? '',
    );
    _selectedRole = widget.employee?.role ?? 'employee';
    _selectedUserType = widget.employee?.userType ?? 'office_employee';
  }

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

  bool get _isEditing => widget.employee != null;

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isEditing) {
        // Update employee
        context.read<UpdateEmployeeCubit>().updateEmployee(
          employeeId: widget.employee!.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          whatsappNumber: _whatsappController.text.trim(),
          userType: _selectedUserType,
        );
      } else {
        // Add new employee
        context.read<AddEmployeeCubit>().addEmployee(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          whatsappNumber: _whatsappController.text.trim(),
          address: _addressController.text.trim(),
          role: _selectedRole,
          userType: _selectedUserType,
        );
      }
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

    // Use different listeners based on whether we're editing or adding
    if (_isEditing) {
      return BlocListener<UpdateEmployeeCubit, UpdateEmployeeState>(
        listener: (context, state) {
          if (state is UpdateEmployeeSuccess) {
            _showSnackBar(state.message);
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.of(context).pop(true);
              }
            });
          } else if (state is UpdateEmployeeError) {
            _showSnackBar(state.message, isError: true);
          }
        },
        child: _buildForm(context, localizations, isArabic, isDark),
      );
    } else {
      return BlocListener<AddEmployeeCubit, AddEmployeeState>(
        listener: (context, state) {
          if (state is AddEmployeeSuccess) {
            _showSnackBar(state.message);
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.of(context).pop(true);
              }
            });
          } else if (state is AddEmployeeError) {
            _showSnackBar(state.message, isError: true);
          }
        },
        child: _buildForm(context, localizations, isArabic, isDark),
      );
    }
  }

  Widget _buildForm(
    BuildContext context,
    AppLocalizations localizations,
    bool isArabic,
    bool isDark,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  _isEditing
                      ? (isArabic ? 'تحديث الموظف' : 'Update Employee')
                      : localizations.translate('add_employee'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Two Column Layout
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      child: Column(
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
                          const SizedBox(height: 20),

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
                          const SizedBox(height: 20),

                          // Password Field (only for new employees)
                          if (!_isEditing) ...[
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
                                  color: isDark
                                      ? AppColors.darkIcon
                                      : AppColors.grey,
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
                            const SizedBox(height: 20),
                          ],

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
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Right Column
                    Expanded(
                      child: Column(
                        children: [
                          // WhatsApp Number Field
                          _buildTextField(
                            controller: _whatsappController,
                            label: localizations.translate('whatsapp_number'),
                            hint: localizations.translate('enter_whatsapp'),
                            icon: Icons.chat_outlined,
                            keyboardType: TextInputType.phone,
                            isDark: isDark,
                            isArabic: isArabic,
                            validator: _isEditing
                                ? null // Optional when editing
                                : (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return isArabic
                                          ? 'الرجاء إدخال رقم الواتساب'
                                          : 'Please enter WhatsApp number';
                                    }
                                    return null;
                                  },
                          ),
                          const SizedBox(height: 20),

                          // Address Field (only for new employees)
                          if (!_isEditing) ...[
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
                            const SizedBox(height: 20),
                          ],

                          // User Type Dropdown
                          _buildUserTypeDropdown(
                            localizations: localizations,
                            isArabic: isArabic,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 20),

                          // Role Selection (only for new employees)
                          if (!_isEditing) ...[
                            _buildRoleSelector(
                              localizations: localizations,
                              isArabic: isArabic,
                              isDark: isDark,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit Button
                Builder(
                  builder: (context) {
                    final isLoading = _isEditing
                        ? context.watch<UpdateEmployeeCubit>().state
                              is UpdateEmployeeLoading
                        : context.watch<AddEmployeeCubit>().state
                              is AddEmployeeLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                _isEditing
                                    ? (isArabic
                                          ? 'تحديث الموظف'
                                          : 'Update Employee')
                                    : localizations.translate('add_employee'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
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
            fillColor: isDark ? AppColors.darkCard : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
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
            color: isDark ? AppColors.darkCard : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
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
              : (isDark ? AppColors.darkCard : Colors.grey.shade50),
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

  Widget _buildUserTypeDropdown({
    required AppLocalizations localizations,
    required bool isArabic,
    required bool isDark,
  }) {
    final userTypes = {
      'admin': isArabic ? 'مدير النظام' : 'Admin',
      'office_owner': isArabic ? 'مالك المكتب' : 'Office Owner',
      'office_employee': isArabic ? 'موظف المكتب' : 'Office Employee',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'نوع المستخدم' : 'User Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedUserType,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.darkCard : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            prefixIcon: Icon(
              Icons.badge_outlined,
              color: isDark ? AppColors.darkIcon : AppColors.grey,
            ),
          ),
          dropdownColor: isDark ? AppColors.darkCard : Colors.white,
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 14,
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: isDark ? AppColors.darkIcon : AppColors.grey,
          ),
          items: userTypes.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedUserType = value;
              });
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isArabic
                  ? 'الرجاء اختيار نوع المستخدم'
                  : 'Please select user type';
            }
            return null;
          },
        ),
      ],
    );
  }
}
