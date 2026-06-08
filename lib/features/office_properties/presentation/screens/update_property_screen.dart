import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../property_types/domain/entities/property_type_entity.dart';
import '../../../property_types/presentation/cubit/property_types_cubit.dart';
import '../../../property_types/presentation/cubit/property_types_state.dart';
import '../../../offer_types/domain/entities/offer_type_entity.dart';
import '../../../offer_types/presentation/cubit/offer_types_cubit.dart';
import '../../../offer_types/presentation/cubit/offer_types_state.dart';
import '../../../governorates/domain/entities/governorate_entity.dart';
import '../../../governorates/presentation/cubit/governorates_cubit.dart';
import '../../../governorates/presentation/cubit/governorates_state.dart';
import '../../domain/entities/property_details_entity.dart'
    hide PropertyTypeEntity, OfferTypeEntity;
import '../cubit/update_property_cubit.dart';
import '../cubit/update_property_state.dart';
import '../widgets/property_form_field.dart';

class UpdatePropertyScreen extends StatefulWidget {
  final PropertyDetailsEntity property;

  const UpdatePropertyScreen({super.key, required this.property});

  @override
  State<UpdatePropertyScreen> createState() => _UpdatePropertyScreenState();
}

class _UpdatePropertyScreenState extends State<UpdatePropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  // Selected values
  PropertyTypeEntity? _selectedPropertyType;
  OfferTypeEntity? _selectedOfferType;
  GovernorateEntity? _selectedGovernorate;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing values
    _titleController = TextEditingController(text: widget.property.title);
    _descriptionController = TextEditingController(
      text: widget.property.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.property.price?.toString() ?? '',
    );

    // Load dropdown data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyTypesCubit>().getPropertyTypes();
      context.read<OfferTypesCubit>().getOfferTypes();
      context.read<GovernoratesCubit>().getGovernorates();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Only send fields that have changed
    final hasChanges =
        _titleController.text != widget.property.title ||
        _descriptionController.text != (widget.property.description ?? '') ||
        (_priceController.text.isNotEmpty &&
            double.tryParse(_priceController.text) != widget.property.price) ||
        (_selectedPropertyType != null &&
            _selectedPropertyType!.id != widget.property.propertyTypeId) ||
        (_selectedOfferType != null &&
            _selectedOfferType!.id != widget.property.offerTypeId) ||
        (_selectedGovernorate != null &&
            _selectedGovernorate!.id != widget.property.governorateId);

    if (!hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا توجد تغييرات لحفظها'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<UpdatePropertyCubit>().updateProperty(
      propertyId: widget.property.id,
      title: _titleController.text != widget.property.title
          ? _titleController.text
          : null,
      description:
          _descriptionController.text != (widget.property.description ?? '')
          ? _descriptionController.text
          : null,
      price:
          _priceController.text.isNotEmpty &&
              double.tryParse(_priceController.text) != widget.property.price
          ? double.tryParse(_priceController.text)
          : null,
      propertyTypeId:
          _selectedPropertyType != null &&
              _selectedPropertyType!.id != widget.property.propertyTypeId
          ? _selectedPropertyType!.id
          : null,
      offerTypeId:
          _selectedOfferType != null &&
              _selectedOfferType!.id != widget.property.offerTypeId
          ? _selectedOfferType!.id
          : null,
      governorateId:
          _selectedGovernorate != null &&
              _selectedGovernorate!.id != widget.property.governorateId
          ? _selectedGovernorate!.id
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحديث العقار'), centerTitle: true),
      body: BlocConsumer<UpdatePropertyCubit, UpdatePropertyState>(
        listener: (context, state) {
          if (state is UpdatePropertySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.response.message ?? 'تم تحديث العقار بنجاح',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            Navigator.of(context).pop(true); // Return true to indicate success
          } else if (state is UpdatePropertyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.error)),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is UpdatePropertyLoading;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Field
                  PropertyFormField(
                    label: 'عنوان العقار',
                    controller: _titleController,
                    hint: 'أدخل عنوان العقار',
                    prefixIcon: Icons.title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال عنوان العقار';
                      }
                      if (value.length < 5) {
                        return 'العنوان يجب أن يكون 5 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Property Type Dropdown
                  BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
                    builder: (context, propertyTypesState) {
                      if (propertyTypesState is PropertyTypesSuccess) {
                        // Set initial value if not set
                        if (_selectedPropertyType == null &&
                            widget.property.propertyTypeId != null) {
                          _selectedPropertyType = propertyTypesState
                              .response
                              .propertyTypes
                              .firstWhere(
                                (type) =>
                                    type.id == widget.property.propertyTypeId,
                                orElse: () => propertyTypesState
                                    .response
                                    .propertyTypes
                                    .first,
                              );
                        }

                        return DropdownButtonFormField<PropertyTypeEntity>(
                          value: _selectedPropertyType,
                          decoration: InputDecoration(
                            labelText: 'نوع العقار',
                            prefixIcon: const Icon(Icons.home_work),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: propertyTypesState.response.propertyTypes
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedPropertyType = value);
                          },
                        );
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Offer Type Dropdown
                  BlocBuilder<OfferTypesCubit, OfferTypesState>(
                    builder: (context, offerTypesState) {
                      if (offerTypesState is OfferTypesSuccess) {
                        // Set initial value if not set
                        if (_selectedOfferType == null &&
                            widget.property.offerTypeId != null) {
                          _selectedOfferType = offerTypesState
                              .response
                              .offerTypes
                              .firstWhere(
                                (type) =>
                                    type.id == widget.property.offerTypeId,
                                orElse: () =>
                                    offerTypesState.response.offerTypes.first,
                              );
                        }

                        return DropdownButtonFormField<OfferTypeEntity>(
                          value: _selectedOfferType,
                          decoration: InputDecoration(
                            labelText: 'نوع العرض',
                            prefixIcon: const Icon(Icons.local_offer),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: offerTypesState.response.offerTypes
                              .map(
                                (type) => DropdownMenuItem<OfferTypeEntity>(
                                  value: type,
                                  child: Text(type.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedOfferType = value);
                          },
                        );
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description Field
                  PropertyFormField(
                    label: 'الوصف',
                    controller: _descriptionController,
                    hint: 'أدخل وصف العقار',
                    prefixIcon: Icons.description,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال وصف العقار';
                      }
                      if (value.length < 10) {
                        return 'الوصف يجب أن يكون 10 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Governorate Dropdown
                  BlocBuilder<GovernoratesCubit, GovernoratesState>(
                    builder: (context, governoratesState) {
                      if (governoratesState is GovernoratesSuccess) {
                        // Set initial value if not set
                        if (_selectedGovernorate == null &&
                            widget.property.governorateId != null) {
                          _selectedGovernorate = governoratesState
                              .response
                              .governorates
                              .firstWhere(
                                (gov) =>
                                    gov.id == widget.property.governorateId,
                                orElse: () => governoratesState
                                    .response
                                    .governorates
                                    .first,
                              );
                        }

                        return DropdownButtonFormField<GovernorateEntity>(
                          value: _selectedGovernorate,
                          decoration: InputDecoration(
                            labelText: 'المحافظة',
                            prefixIcon: const Icon(Icons.location_city),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: governoratesState.response.governorates
                              .map(
                                (gov) => DropdownMenuItem(
                                  value: gov,
                                  child: Text(gov.nameAr),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedGovernorate = value);
                          },
                        );
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Price Field
                  PropertyFormField(
                    label: 'السعر',
                    controller: _priceController,
                    hint: 'أدخل السعر',
                    prefixIcon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال السعر';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'الرجاء إدخال سعر صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Update Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleUpdate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'تحديث العقار',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
