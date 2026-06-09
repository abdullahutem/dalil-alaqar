import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/office_info_cubit.dart';
import '../cubit/office_info_state.dart';
import '../../domain/entities/office_info_entity.dart';

class UpdateOfficeInfoScreen extends StatefulWidget {
  final OfficeInfoEntity officeInfo;

  const UpdateOfficeInfoScreen({super.key, required this.officeInfo});

  @override
  State<UpdateOfficeInfoScreen> createState() => _UpdateOfficeInfoScreenState();
}

class _UpdateOfficeInfoScreenState extends State<UpdateOfficeInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _whatsappController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  late final TextEditingController _facebookController;
  late final TextEditingController _instagramController;
  late final TextEditingController _twitterController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.officeInfo.phone);
    _whatsappController = TextEditingController(
      text: widget.officeInfo.whatsappNumber ?? '',
    );
    _emailController = TextEditingController(text: widget.officeInfo.email);
    _websiteController = TextEditingController(
      text: widget.officeInfo.website ?? '',
    );
    _facebookController = TextEditingController(
      text: widget.officeInfo.facebook ?? '',
    );
    _instagramController = TextEditingController(
      text: widget.officeInfo.instagram ?? '',
    );
    _twitterController = TextEditingController(
      text: widget.officeInfo.twitter ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.officeInfo.description ?? '',
    );
    _addressController = TextEditingController(
      text: widget.officeInfo.address ?? '',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      final updateData = {
        'phone': _phoneController.text.trim(),
        'whatsapp_number': _whatsappController.text.trim(),
        'email': _emailController.text.trim(),
        'website': _websiteController.text.trim(),
        'facebook': _facebookController.text.trim(),
        'instagram': _instagramController.text.trim(),
        'twitter': _twitterController.text.trim(),
        'description': _descriptionController.text.trim(),
        'address': _addressController.text.trim(),
      };

      context.read<OfficeInfoCubit>().updateOfficeInfo(updateData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديث معلومات المكتب'),
        centerTitle: true,
      ),
      body: BlocConsumer<OfficeInfoCubit, OfficeInfoState>(
        listener: (context, state) {
          if (state is OfficeInfoUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is OfficeInfoUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is OfficeInfoUpdating;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('معلومات الاتصال', theme),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'رقم الهاتف',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _whatsappController,
                    label: 'رقم الواتساب',
                    icon: Icons.chat_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!value.contains('@')) {
                        return 'الرجاء إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'العنوان',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('روابط التواصل الاجتماعي', theme),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _websiteController,
                    label: 'الموقع الإلكتروني',
                    icon: Icons.language_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _facebookController,
                    label: 'فيسبوك',
                    icon: Icons.facebook_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _instagramController,
                    label: 'إنستغرام',
                    icon: Icons.camera_alt_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _twitterController,
                    label: 'تويتر',
                    icon: Icons.alternate_email_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('الوصف', theme),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'وصف المكتب',
                    icon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleUpdate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                        : const Text(
                            'حفظ التغييرات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
