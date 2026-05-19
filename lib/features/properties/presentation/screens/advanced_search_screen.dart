import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_cubit.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_state.dart';
import 'package:dalil_alaqar/features/property_types/presentation/widgets/property_type_filter_chip.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_cubit.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_state.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/widgets/offer_type_filter_chip.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_cubit.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_state.dart';
import 'package:dalil_alaqar/features/governorates/presentation/widgets/governorate_filter_chip.dart';
import 'package:dalil_alaqar/features/districts/presentation/cubit/districts_cubit.dart';
import 'package:dalil_alaqar/features/districts/presentation/cubit/districts_state.dart';
import 'package:dalil_alaqar/features/districts/presentation/widgets/district_filter_chip.dart';
import 'package:dalil_alaqar/features/neighborhoods/presentation/cubit/neighborhoods_cubit.dart';
import 'package:dalil_alaqar/features/neighborhoods/presentation/cubit/neighborhoods_state.dart';
import 'package:dalil_alaqar/features/neighborhoods/presentation/widgets/neighborhood_filter_chip.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  int? selectedOfferTypeId;
  int? selectedPropertyTypeId;
  int? selectedGovernorateId;
  int? selectedDistrictId;
  int? selectedNeighborhoodId;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      // Load all filter data
      context.read<OfferTypesCubit>().getOfferTypes();
      context.read<PropertyTypesCubit>().getPropertyTypes();
      context.read<GovernoratesCubit>().getGovernorates();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _onGovernorateSelected(int? governorateId) {
    setState(() {
      selectedGovernorateId = governorateId;
      selectedDistrictId = null;
      selectedNeighborhoodId = null;
    });
    if (governorateId != null) {
      context.read<DistrictsCubit>().getDistrictsByGovernorate(governorateId);
    } else {
      context.read<DistrictsCubit>().clearDistricts();
    }
    context.read<NeighborhoodsCubit>().clearNeighborhoods();
  }

  void _onDistrictSelected(int? districtId) {
    setState(() {
      selectedDistrictId = districtId;
      selectedNeighborhoodId = null;
    });
    if (districtId != null) {
      context.read<NeighborhoodsCubit>().getNeighborhoodsByDistrict(districtId);
    } else {
      context.read<NeighborhoodsCubit>().clearNeighborhoods();
    }
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      selectedOfferTypeId = null;
      selectedPropertyTypeId = null;
      selectedGovernorateId = null;
      selectedDistrictId = null;
      selectedNeighborhoodId = null;
    });
    context.read<DistrictsCubit>().clearDistricts();
    context.read<NeighborhoodsCubit>().clearNeighborhoods();
  }

  void _applyFilters() {
    final searchParams = {
      'search': _searchController.text.isNotEmpty
          ? _searchController.text
          : null,
      'propertyTypeId': selectedPropertyTypeId,
      'offerTypeId': selectedOfferTypeId,
      'governorateId': selectedGovernorateId,
      'districtId': selectedDistrictId,
      'neighborhoodId': selectedNeighborhoodId,
      'minPrice': _minPriceController.text.isNotEmpty
          ? double.tryParse(_minPriceController.text)
          : null,
      'maxPrice': _maxPriceController.text.isNotEmpty
          ? double.tryParse(_maxPriceController.text)
          : null,
    };

    Navigator.pop(context, searchParams);
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (_searchController.text.isNotEmpty) count++;
    if (selectedOfferTypeId != null) count++;
    if (selectedPropertyTypeId != null) count++;
    if (selectedGovernorateId != null) count++;
    if (selectedDistrictId != null) count++;
    if (selectedNeighborhoodId != null) count++;
    if (_minPriceController.text.isNotEmpty) count++;
    if (_maxPriceController.text.isNotEmpty) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بحث متقدم'),
        backgroundColor: AppColors.primary,
        actions: [
          if (_getActiveFiltersCount() > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_getActiveFiltersCount()} فلتر',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          if (_getActiveFiltersCount() > 0)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearAllFilters,
              tooltip: 'مسح جميع الفلاتر',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 24),
                  _buildOfferTypesSection(),
                  const SizedBox(height: 24),
                  _buildPropertyTypesSection(),
                  const SizedBox(height: 24),
                  _buildPriceRangeSection(),
                  const SizedBox(height: 24),
                  _buildLocationSection(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'البحث بالكلمات',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'ابحث عن عقار...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildOfferTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع العرض',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BlocBuilder<OfferTypesCubit, OfferTypesState>(
          builder: (context, state) {
            if (state is OfferTypesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OfferTypesSuccess) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.response.offerTypes.map((type) {
                  return OfferTypeFilterChip(
                    offerType: type,
                    isSelected: selectedOfferTypeId == type.id,
                    onTap: () {
                      setState(() {
                        selectedOfferTypeId = selectedOfferTypeId == type.id
                            ? null
                            : type.id;
                      });
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildPropertyTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع العقار',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
          builder: (context, state) {
            if (state is PropertyTypesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PropertyTypesSuccess) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.response.propertyTypes.map((type) {
                  return PropertyTypeFilterChip(
                    propertyType: type,
                    isSelected: selectedPropertyTypeId == type.id,
                    onTap: () {
                      setState(() {
                        selectedPropertyTypeId =
                            selectedPropertyTypeId == type.id ? null : type.id;
                      });
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نطاق السعر (ريال)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'من',
                  hintText: '0',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'إلى',
                  hintText: '∞',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الموقع',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildGovernoratesFilter(),
        if (selectedGovernorateId != null) ...[
          const SizedBox(height: 16),
          _buildDistrictsFilter(),
        ],
        if (selectedDistrictId != null) ...[
          const SizedBox(height: 16),
          _buildNeighborhoodsFilter(),
        ],
      ],
    );
  }

  Widget _buildGovernoratesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المحافظة',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        BlocBuilder<GovernoratesCubit, GovernoratesState>(
          builder: (context, state) {
            if (state is GovernoratesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GovernoratesSuccess) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.response.governorates.map((gov) {
                  return GovernorateFilterChip(
                    governorate: gov,
                    isSelected: selectedGovernorateId == gov.id,
                    showDistrictsCount: true,
                    onTap: () {
                      _onGovernorateSelected(
                        selectedGovernorateId == gov.id ? null : gov.id,
                      );
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildDistrictsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المديرية',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        BlocBuilder<DistrictsCubit, DistrictsState>(
          builder: (context, state) {
            if (state is DistrictsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DistrictsSuccess) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.response.districts.map((district) {
                  return DistrictFilterChip(
                    district: district,
                    isSelected: selectedDistrictId == district.id,
                    onTap: () {
                      _onDistrictSelected(
                        selectedDistrictId == district.id ? null : district.id,
                      );
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildNeighborhoodsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الحي',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        BlocBuilder<NeighborhoodsCubit, NeighborhoodsState>(
          builder: (context, state) {
            if (state is NeighborhoodsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NeighborhoodsSuccess) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.response.neighborhoods.map((neighborhood) {
                  return NeighborhoodFilterChip(
                    neighborhood: neighborhood,
                    isSelected: selectedNeighborhoodId == neighborhood.id,
                    onTap: () {
                      setState(() {
                        selectedNeighborhoodId =
                            selectedNeighborhoodId == neighborhood.id
                            ? null
                            : neighborhood.id;
                      });
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    final activeFiltersCount = _getActiveFiltersCount();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (activeFiltersCount > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _clearAllFilters,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  'مسح الكل',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          if (activeFiltersCount > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                activeFiltersCount > 0
                    ? 'تطبيق ($activeFiltersCount)'
                    : 'عرض جميع العقارات',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
