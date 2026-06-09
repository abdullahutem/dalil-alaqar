import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../property_types/domain/entities/property_type_entity.dart';
import '../../../property_types/presentation/cubit/property_types_cubit.dart';
import '../../../property_types/presentation/cubit/property_types_state.dart';
import '../../../offer_types/domain/entities/offer_type_entity.dart'
    as offer_types;
import '../../../offer_types/presentation/cubit/offer_types_cubit.dart';
import '../../../offer_types/presentation/cubit/offer_types_state.dart';
import '../../../currencies/domain/entities/currency_entity.dart';
import '../../../currencies/presentation/cubit/currencies_cubit.dart';
import '../../../currencies/presentation/cubit/currencies_state.dart';
import '../../../governorates/domain/entities/governorate_entity.dart';
import '../../../governorates/presentation/cubit/governorates_cubit.dart';
import '../../../governorates/presentation/cubit/governorates_state.dart';
import '../../../districts/domain/entities/district_entity.dart';
import '../../../districts/presentation/cubit/districts_cubit.dart';
import '../../../districts/presentation/cubit/districts_state.dart';
import '../../../neighborhoods/domain/entities/neighborhood_entity.dart';
import '../../../neighborhoods/presentation/cubit/neighborhoods_cubit.dart';
import '../../../neighborhoods/presentation/cubit/neighborhoods_state.dart';
import '../../domain/entities/property_details_entity.dart'
    hide PropertyTypeEntity, OfferTypeEntity;
import '../cubit/update_property_cubit.dart';
import '../cubit/update_property_state.dart';
import '../widgets/property_form_field.dart';

class OfficeUpdatePropertyScreen extends StatefulWidget {
  final PropertyDetailsEntity property;

  const OfficeUpdatePropertyScreen({super.key, required this.property});

  @override
  State<OfficeUpdatePropertyScreen> createState() =>
      _OfficeUpdatePropertyScreenState();
}

class _OfficeUpdatePropertyScreenState
    extends State<OfficeUpdatePropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _addressController;

  // Selected values
  PropertyTypeEntity? _selectedPropertyType;
  offer_types.OfferTypeEntity? _selectedOfferType;
  CurrencyEntity? _selectedCurrency;
  GovernorateEntity? _selectedGovernorate;
  DistrictEntity? _selectedDistrict;
  NeighborhoodEntity? _selectedNeighborhood;
  late bool _priceNegotiable;

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
    _addressController = TextEditingController(
      text: widget.property.address ?? '',
    );
    _priceNegotiable = widget.property.priceNegotiable;

    // Load dropdown data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyTypesCubit>().getPropertyTypes();
      context.read<OfferTypesCubit>().getOfferTypes();
      context.read<CurrenciesCubit>().getCurrencies();
      context.read<GovernoratesCubit>().getGovernorates();

      // Load districts if governorate is set
      if (widget.property.governorateId != null) {
        context.read<DistrictsCubit>().getDistrictsByGovernorate(
          widget.property.governorateId!,
        );
      }

      // Load neighborhoods if district is set
      if (widget.property.districtId != null) {
        context.read<NeighborhoodsCubit>().getNeighborhoodsByDistrict(
          widget.property.districtId!,
        );
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPropertyType == null ||
        _selectedOfferType == null ||
        _selectedCurrency == null ||
        _selectedGovernorate == null ||
        _selectedDistrict == null ||
        _selectedNeighborhood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تعبئة جميع الحقول المطلوبة'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<UpdatePropertyCubit>().updateProperty(
      propertyId: widget.property.id,
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      propertyTypeId: _selectedPropertyType!.id,
      offerTypeId: _selectedOfferType!.id,
      governorateId: _selectedGovernorate!.id,
      districtId: _selectedDistrict!.id,
      neighborhoodId: _selectedNeighborhood!.id,
      address: _addressController.text,
      priceNegotiable: _priceNegotiable,
      currencyId: _selectedCurrency!.id,
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
                    Expanded(child: Text(state.response.message)),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            Navigator.of(context).pop(true);
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
                  // Basic Info Section
                  _buildSectionHeader('المعلومات الأساسية'),
                  const SizedBox(height: 16),

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

                  _buildPropertyTypeDropdown(),
                  const SizedBox(height: 16),

                  _buildOfferTypeDropdown(),
                  const SizedBox(height: 16),

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

                  const SizedBox(height: 32),

                  // Price Section
                  _buildSectionHeader('السعر'),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 16),

                  _buildCurrencyDropdown(),
                  const SizedBox(height: 8),

                  CheckboxListTile(
                    value: _priceNegotiable,
                    onChanged: (value) {
                      setState(() => _priceNegotiable = value ?? false);
                    },
                    title: const Text(
                      'السعر قابل للتفاوض',
                      textAlign: TextAlign.right,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 32),

                  // Location Section
                  _buildSectionHeader('الموقع'),
                  const SizedBox(height: 16),

                  PropertyFormField(
                    label: 'العنوان',
                    controller: _addressController,
                    hint: 'أدخل عنوان العقار',
                    prefixIcon: Icons.location_on,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال العنوان';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildGovernorateDropdown(),
                  const SizedBox(height: 16),

                  _buildDistrictDropdown(),
                  const SizedBox(height: 16),

                  _buildNeighborhoodDropdown(),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildPropertyTypeDropdown() {
    return BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
      builder: (context, state) {
        if (state is PropertyTypesSuccess) {
          if (_selectedPropertyType == null &&
              widget.property.propertyTypeId != null) {
            try {
              _selectedPropertyType = state.response.propertyTypes.firstWhere(
                (type) => type.id == widget.property.propertyTypeId,
              );
            } catch (e) {
              if (state.response.propertyTypes.isNotEmpty) {
                _selectedPropertyType = state.response.propertyTypes.first;
              }
            }
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
            items: state.response.propertyTypes
                .map(
                  (type) =>
                      DropdownMenuItem(value: type, child: Text(type.name)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => _selectedPropertyType = value);
            },
          );
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Widget _buildOfferTypeDropdown() {
    return BlocBuilder<OfferTypesCubit, OfferTypesState>(
      builder: (context, state) {
        if (state is OfferTypesSuccess) {
          if (_selectedOfferType == null &&
              widget.property.offerTypeId != null) {
            try {
              _selectedOfferType = state.response.offerTypes.firstWhere(
                (type) => type.id == widget.property.offerTypeId,
              );
            } catch (e) {
              if (state.response.offerTypes.isNotEmpty) {
                _selectedOfferType = state.response.offerTypes.first;
              }
            }
          }

          return DropdownButtonFormField<offer_types.OfferTypeEntity>(
            value: _selectedOfferType,
            decoration: InputDecoration(
              labelText: 'نوع العرض',
              prefixIcon: const Icon(Icons.local_offer),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: state.response.offerTypes
                .map(
                  (type) => DropdownMenuItem<offer_types.OfferTypeEntity>(
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
    );
  }

  Widget _buildCurrencyDropdown() {
    return BlocBuilder<CurrenciesCubit, CurrenciesState>(
      builder: (context, state) {
        if (state is CurrenciesSuccess) {
          if (_selectedCurrency == null && widget.property.currencyId != null) {
            try {
              _selectedCurrency = state.response.currencies.firstWhere(
                (currency) => currency.id == widget.property.currencyId,
              );
            } catch (e) {
              if (state.response.currencies.isNotEmpty) {
                _selectedCurrency = state.response.currencies.first;
              }
            }
          }

          return DropdownButtonFormField<CurrencyEntity>(
            value: _selectedCurrency,
            decoration: InputDecoration(
              labelText: 'العملة',
              prefixIcon: const Icon(Icons.monetization_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: state.response.currencies
                .map(
                  (currency) => DropdownMenuItem(
                    value: currency,
                    child: Text('${currency.name} (${currency.symbol})'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() => _selectedCurrency = value);
            },
          );
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Widget _buildGovernorateDropdown() {
    return BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        if (state is GovernoratesSuccess) {
          if (_selectedGovernorate == null &&
              widget.property.governorateId != null) {
            try {
              _selectedGovernorate = state.response.governorates.firstWhere(
                (gov) => gov.id == widget.property.governorateId,
              );
            } catch (e) {
              if (state.response.governorates.isNotEmpty) {
                _selectedGovernorate = state.response.governorates.first;
              }
            }
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
            items: state.response.governorates
                .map(
                  (gov) =>
                      DropdownMenuItem(value: gov, child: Text(gov.nameAr)),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedGovernorate = value;
                _selectedDistrict = null;
                _selectedNeighborhood = null;
              });
              if (value != null) {
                context.read<DistrictsCubit>().getDistrictsByGovernorate(
                  value.id,
                );
              }
            },
          );
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Widget _buildDistrictDropdown() {
    return BlocBuilder<DistrictsCubit, DistrictsState>(
      builder: (context, state) {
        if (state is DistrictsSuccess) {
          if (_selectedDistrict == null && widget.property.districtId != null) {
            try {
              _selectedDistrict = state.response.districts.firstWhere(
                (dist) => dist.id == widget.property.districtId,
              );
            } catch (e) {
              if (state.response.districts.isNotEmpty) {
                _selectedDistrict = state.response.districts.first;
              }
            }
          }

          return DropdownButtonFormField<DistrictEntity>(
            value: _selectedDistrict,
            decoration: InputDecoration(
              labelText: 'المديرية',
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: state.response.districts
                .map(
                  (dist) =>
                      DropdownMenuItem(value: dist, child: Text(dist.nameAr)),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedDistrict = value;
                _selectedNeighborhood = null;
              });
              if (value != null) {
                context.read<NeighborhoodsCubit>().getNeighborhoodsByDistrict(
                  value.id,
                );
              }
            },
          );
        }
        if (state is DistrictsLoading) {
          return const LinearProgressIndicator();
        }
        return DropdownButtonFormField<DistrictEntity>(
          value: null,
          decoration: InputDecoration(
            labelText: 'المديرية',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: const [],
          onChanged: null,
        );
      },
    );
  }

  Widget _buildNeighborhoodDropdown() {
    return BlocBuilder<NeighborhoodsCubit, NeighborhoodsState>(
      builder: (context, state) {
        if (state is NeighborhoodsSuccess) {
          if (_selectedNeighborhood == null &&
              widget.property.neighborhoodId != null) {
            try {
              _selectedNeighborhood = state.response.neighborhoods.firstWhere(
                (neigh) => neigh.id == widget.property.neighborhoodId,
              );
            } catch (e) {
              if (state.response.neighborhoods.isNotEmpty) {
                _selectedNeighborhood = state.response.neighborhoods.first;
              }
            }
          }

          return DropdownButtonFormField<NeighborhoodEntity>(
            value: _selectedNeighborhood,
            decoration: InputDecoration(
              labelText: 'الحي',
              prefixIcon: const Icon(Icons.place),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: state.response.neighborhoods
                .map(
                  (neigh) =>
                      DropdownMenuItem(value: neigh, child: Text(neigh.nameAr)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => _selectedNeighborhood = value);
            },
          );
        }
        if (state is NeighborhoodsLoading) {
          return const LinearProgressIndicator();
        }
        return DropdownButtonFormField<NeighborhoodEntity>(
          value: null,
          decoration: InputDecoration(
            labelText: 'الحي',
            prefixIcon: const Icon(Icons.place),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: const [],
          onChanged: null,
        );
      },
    );
  }
}
