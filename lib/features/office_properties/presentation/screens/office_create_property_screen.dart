import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../property_types/domain/entities/property_type_entity.dart';
import '../../../property_types/presentation/cubit/property_types_cubit.dart';
import '../../../property_types/presentation/cubit/property_types_state.dart';
import '../../../offer_types/domain/entities/offer_type_entity.dart';
import '../../../offer_types/presentation/cubit/offer_types_cubit.dart';
import '../../../offer_types/presentation/cubit/offer_types_state.dart';
import '../../../currencies/domain/entities/currency_entity.dart';
import '../../../currencies/presentation/cubit/currencies_cubit.dart';
import '../../../currencies/presentation/cubit/currencies_state.dart';
import '../../../governorates/domain/entities/governorate_entity.dart';
import '../../../districts/domain/entities/district_entity.dart';
import '../../../neighborhoods/domain/entities/neighborhood_entity.dart';
import '../../domain/entities/create_property_entity.dart';
import '../cubit/create_property_cubit.dart';
import '../cubit/create_property_state.dart';
import '../cubit/property_location_cubit.dart';
import '../cubit/property_location_state.dart';
import '../widgets/property_form_field.dart';
import '../widgets/property_location_picker.dart';
import '../widgets/geographic_selection_widget.dart';
import 'office_property_details_screen.dart';

class OfficeCreatePropertyScreen extends StatefulWidget {
  const OfficeCreatePropertyScreen({super.key});

  @override
  State<OfficeCreatePropertyScreen> createState() =>
      _CreatePropertyScreenState();
}

class _CreatePropertyScreenState extends State<OfficeCreatePropertyScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();

  // Selected values
  PropertyTypeEntity? _selectedPropertyType;
  OfferTypeEntity? _selectedOfferType;
  CurrencyEntity? _selectedCurrency; // Changed to CurrencyEntity
  bool _priceNegotiable = false;
  GovernorateEntity? _selectedGovernorate;
  DistrictEntity? _selectedDistrict;
  NeighborhoodEntity? _selectedNeighborhood;

  late CreatePropertyCubit _createPropertyCubit;
  late PropertyLocationCubit _locationCubit;

  @override
  void initState() {
    super.initState();
    _createPropertyCubit = CreatePropertyCubit.create();
    _locationCubit = PropertyLocationCubit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyTypesCubit>().getPropertyTypes();
      context.read<OfferTypesCubit>().getOfferTypes();
      context.read<CurrenciesCubit>().getCurrencies();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _createPropertyCubit.close();
    _locationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _createPropertyCubit),
        BlocProvider.value(value: _locationCubit),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('إضافة عقار جديد'), centerTitle: true),
        body: BlocConsumer<CreatePropertyCubit, CreatePropertyState>(
          listener: (context, state) {
            if (state is CreatePropertySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );

              // Navigate to property details
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) =>
                      PropertyDetailsScreen(propertyId: state.property.id),
                ),
              );
            } else if (state is CreatePropertyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            } else if (state is CreatePropertyValidationError) {
              // Show first validation error
              final firstError = state.errors.values.first;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(firstError),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is CreatePropertyLoading;

            return Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _onStepContinue,
                onStepCancel: _onStepCancel,
                onStepTapped: (step) => setState(() => _currentStep = step),
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        if (_currentStep < 3)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('التالي'),
                            ),
                          ),
                        if (_currentStep == 3)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check, size: 20),
                                        SizedBox(width: 8),
                                        Text('إضافة العقار'),
                                      ],
                                    ),
                            ),
                          ),
                        if (_currentStep > 0) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : details.onStepCancel,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('السابق'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('المعلومات الأساسية'),
                    content: _buildBasicInfoStep(isDark),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('السعر'),
                    content: _buildPriceStep(isDark),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('الموقع'),
                    content: _buildLocationStep(isDark),
                    isActive: _currentStep >= 2,
                    state: _currentStep > 2
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('المراجعة'),
                    content: _buildReviewStep(),
                    isActive: _currentStep >= 3,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'معلومات العقار',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 16),

        // Property Type Dropdown
        BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
          builder: (context, state) {
            if (state is PropertyTypesSuccess) {
              return DropdownButtonFormField<PropertyTypeEntity>(
                initialValue: _selectedPropertyType,
                decoration: InputDecoration(
                  labelText: 'نوع العقار',
                  prefixIcon: Icon(
                    Icons.home,
                    color: isDark ? AppColors.darkIcon : AppColors.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                ),
                items: state.response.propertyTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(type.name, textDirection: TextDirection.rtl),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedPropertyType = value),
                validator: (value) =>
                    value == null ? 'الرجاء اختيار نوع العقار' : null,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),

        const SizedBox(height: 16),

        // Offer Type Dropdown
        BlocBuilder<OfferTypesCubit, OfferTypesState>(
          builder: (context, state) {
            if (state is OfferTypesSuccess) {
              return DropdownButtonFormField<OfferTypeEntity>(
                initialValue: _selectedOfferType,
                decoration: InputDecoration(
                  labelText: 'نوع العرض',
                  prefixIcon: const Icon(Icons.sell),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                ),
                items: state.response.offerTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(type.name, textDirection: TextDirection.rtl),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedOfferType = value),
                validator: (value) =>
                    value == null ? 'الرجاء اختيار نوع العرض' : null,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),

        const SizedBox(height: 16),

        PropertyFormField(
          controller: _titleController,
          label: 'عنوان العقار',
          hint: 'مثال: فيلا فاخرة في حي السعادة',
          prefixIcon: Icons.title,
          isDark: isDark,

          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'العنوان مطلوب';
            }
            if (value.trim().length < 10) {
              return 'العنوان يجب أن يكون 10 أحرف على الأقل';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        PropertyFormField(
          controller: _descriptionController,
          label: 'الوصف',
          hint: 'أدخل وصف تفصيلي للعقار',
          prefixIcon: Icons.description,
          maxLines: 5,
          maxLength: 1000,
          isDark: isDark,

          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'الوصف مطلوب';
            }
            if (value.trim().length < 20) {
              return 'الوصف يجب أن يكون 20 حرف على الأقل';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPriceStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'معلومات السعر',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 16),

        PropertyFormField(
          controller: _priceController,
          label: 'السعر',
          hint: '0',
          prefixIcon: Icons.attach_money,
          keyboardType: TextInputType.number,
          isDark: isDark,

          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffix: _selectedCurrency != null
              ? Text(
                  _selectedCurrency!.symbol,
                  style: const TextStyle(fontSize: 16),
                )
              : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'السعر مطلوب';
            }
            final price = double.tryParse(value);
            if (price == null || price <= 0) {
              return 'السعر يجب أن يكون أكبر من صفر';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Currency Dropdown
        BlocBuilder<CurrenciesCubit, CurrenciesState>(
          builder: (context, state) {
            if (state is CurrenciesSuccess) {
              // Set default currency if not selected
              if (_selectedCurrency == null &&
                  state.response.currencies.isNotEmpty) {
                CurrencyEntity? defaultCurrency;
                try {
                  defaultCurrency = state.response.currencies.firstWhere(
                    (currency) => currency.isDefault,
                  );
                } catch (e) {
                  defaultCurrency = state.response.currencies.first;
                }
                _selectedCurrency = defaultCurrency;
              }

              return DropdownButtonFormField<CurrencyEntity>(
                initialValue: _selectedCurrency,
                decoration: InputDecoration(
                  labelText: 'العملة',
                  prefixIcon: const Icon(Icons.monetization_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                ),
                items: state.response.currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${currency.name} (${currency.symbol})',
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCurrency = value),
                validator: (value) =>
                    value == null ? 'الرجاء اختيار العملة' : null,
              );
            }
            if (state is CurrenciesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CurrenciesError) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.message,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        const SizedBox(height: 16),

        CheckboxListTile(
          value: _priceNegotiable,
          onChanged: (value) =>
              setState(() => _priceNegotiable = value ?? false),
          title: const Text(
            'السعر قابل للتفاوض',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 16),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildLocationStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'موقع العقار',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 16),

        // Map
        SizedBox(
          height: 300,
          child: PropertyLocationPicker(
            onLocationSelected: (position, address) {
              setState(() {
                if (address != null) {
                  _addressController.text = address;
                }
              });
            },
          ),
        ),

        const SizedBox(height: 16),

        PropertyFormField(
          controller: _addressController,
          label: 'العنوان',
          hint: 'سيتم تعبئته تلقائياً من الخريطة',
          prefixIcon: Icons.location_on,
          maxLines: 2,
          isDark: isDark,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'العنوان مطلوب';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        const Text(
          'الموقع الإداري',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 12),

        GeographicSelectionWidget(
          selectedGovernorate: _selectedGovernorate,
          selectedDistrict: _selectedDistrict,
          selectedNeighborhood: _selectedNeighborhood,
          onGovernorateChanged: (value) =>
              setState(() => _selectedGovernorate = value),
          onDistrictChanged: (value) =>
              setState(() => _selectedDistrict = value),
          onNeighborhoodChanged: (value) =>
              setState(() => _selectedNeighborhood = value),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'مراجعة البيانات',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 16),

        _buildReviewCard(
          title: 'المعلومات الأساسية',
          children: [
            _buildReviewItem('نوع العقار', _selectedPropertyType?.name ?? '-'),
            _buildReviewItem('نوع العرض', _selectedOfferType?.name ?? '-'),
            _buildReviewItem(
              'العنوان',
              _titleController.text.isEmpty ? '-' : _titleController.text,
            ),
            _buildReviewItem(
              'الوصف',
              _descriptionController.text.isEmpty
                  ? '-'
                  : _descriptionController.text,
              maxLines: 3,
            ),
          ],
          onEdit: () => setState(() => _currentStep = 0),
        ),

        const SizedBox(height: 16),

        _buildReviewCard(
          title: 'السعر',
          children: [
            _buildReviewItem(
              'السعر',
              _priceController.text.isEmpty
                  ? '-'
                  : '${_priceController.text} ${_selectedCurrency?.symbol ?? ''}',
            ),
            _buildReviewItem('العملة', _selectedCurrency?.name ?? '-'),
            _buildReviewItem('قابل للتفاوض', _priceNegotiable ? 'نعم' : 'لا'),
          ],
          onEdit: () => setState(() => _currentStep = 1),
        ),

        const SizedBox(height: 16),

        _buildReviewCard(
          title: 'الموقع',
          children: [
            _buildReviewItem(
              'العنوان',
              _addressController.text.isEmpty ? '-' : _addressController.text,
              maxLines: 2,
            ),
            _buildReviewItem('المحافظة', _selectedGovernorate?.nameAr ?? '-'),
            _buildReviewItem('المديرية', _selectedDistrict?.nameAr ?? '-'),
            _buildReviewItem('الحي', _selectedNeighborhood?.nameAr ?? '-'),
            BlocBuilder<PropertyLocationCubit, PropertyLocationState>(
              builder: (context, state) {
                final cubit = context.read<PropertyLocationCubit>();
                return _buildReviewItem(
                  'الإحداثيات',
                  '${cubit.currentPosition.latitude.toStringAsFixed(6)}, ${cubit.currentPosition.longitude.toStringAsFixed(6)}',
                );
              },
            ),
          ],
          onEdit: () => setState(() => _currentStep = 2),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String title,
    required List<Widget> children,
    required VoidCallback onEdit,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('تعديل'),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep < 3) {
      if (_validateCurrentStep()) {
        setState(() => _currentStep++);
      }
    } else {
      _submitProperty();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _validateBasicInfo();
      case 1:
        return _validatePrice();
      case 2:
        return _validateLocation();
      default:
        return true;
    }
  }

  bool _validateBasicInfo() {
    if (_selectedPropertyType == null) {
      _showError('الرجاء اختيار نوع العقار');
      return false;
    }
    if (_selectedOfferType == null) {
      _showError('الرجاء اختيار نوع العرض');
      return false;
    }
    if (_titleController.text.trim().isEmpty) {
      _showError('الرجاء إدخال عنوان العقار');
      return false;
    }
    if (_titleController.text.trim().length < 10) {
      _showError('العنوان يجب أن يكون 10 أحرف على الأقل');
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showError('الرجاء إدخال وصف العقار');
      return false;
    }
    if (_descriptionController.text.trim().length < 20) {
      _showError('الوصف يجب أن يكون 20 حرف على الأقل');
      return false;
    }
    return true;
  }

  bool _validatePrice() {
    if (_priceController.text.isEmpty) {
      _showError('الرجاء إدخال السعر');
      return false;
    }
    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      _showError('السعر يجب أن يكون أكبر من صفر');
      return false;
    }
    return true;
  }

  bool _validateLocation() {
    if (_addressController.text.trim().isEmpty) {
      _showError('الرجاء إدخال العنوان');
      return false;
    }
    if (_selectedGovernorate == null) {
      _showError('الرجاء اختيار المحافظة');
      return false;
    }
    if (_selectedDistrict == null) {
      _showError('الرجاء اختيار المديرية');
      return false;
    }
    if (_selectedNeighborhood == null) {
      _showError('الرجاء اختيار الحي');
      return false;
    }
    return true;
  }

  void _submitProperty() {
    final property = CreatePropertyEntity(
      propertyTypeId: _selectedPropertyType!.id,
      offerTypeId: _selectedOfferType!.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text),
      priceNegotiable: _priceNegotiable,
      governorateId: _selectedGovernorate!.id,
      districtId: _selectedDistrict!.id,
      neighborhoodId: _selectedNeighborhood!.id,
      address: _addressController.text.trim(),
      latitude: _locationCubit.currentPosition.latitude,
      longitude: _locationCubit.currentPosition.longitude,
      currencyId: _selectedCurrency!.id,
      status: 'available',
    );

    _createPropertyCubit.createProperty(property);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }
}
