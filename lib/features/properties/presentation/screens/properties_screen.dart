import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';
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
import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/properties_mobile_layout.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/properties_tablet_layout.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PropertiesCubit.create()..getProperties(),
        ),
        BlocProvider(
          create: (context) => PropertyTypesCubit.create()..getPropertyTypes(),
        ),
        BlocProvider(
          create: (context) => OfferTypesCubit.create()..getOfferTypes(),
        ),
        BlocProvider(
          create: (context) => GovernoratesCubit.create()..getGovernorates(),
        ),
        BlocProvider(create: (context) => DistrictsCubit.create()),
        BlocProvider(create: (context) => NeighborhoodsCubit.create()),
      ],
      child: const _PropertiesScreenContent(),
    );
  }
}

class _PropertiesScreenContent extends StatefulWidget {
  const _PropertiesScreenContent();

  @override
  State<_PropertiesScreenContent> createState() =>
      _PropertiesScreenContentState();
}

class _PropertiesScreenContentState extends State<_PropertiesScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  bool _showAdvancedFilters = false;

  int? selectedOfferTypeId;
  int? selectedPropertyTypeId;
  int? selectedGovernorateId;
  int? selectedDistrictId;
  int? selectedNeighborhoodId;

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applySearch() {
    context.read<PropertiesCubit>().getProperties(
      refresh: true,
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
      propertyTypeId: selectedPropertyTypeId,
      offerTypeId: selectedOfferTypeId,
      governorateId: selectedGovernorateId,
      districtId: selectedDistrictId,
      neighborhoodId: selectedNeighborhoodId,
      minPrice: _minPriceController.text.isNotEmpty
          ? double.tryParse(_minPriceController.text)
          : null,
      maxPrice: _maxPriceController.text.isNotEmpty
          ? double.tryParse(_maxPriceController.text)
          : null,
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      selectedOfferTypeId = null;
      selectedPropertyTypeId = null;
      selectedGovernorateId = null;
      selectedDistrictId = null;
      selectedNeighborhoodId = null;
      _showAdvancedFilters = false;
    });
    context.read<DistrictsCubit>().clearDistricts();
    context.read<NeighborhoodsCubit>().clearNeighborhoods();
    context.read<PropertiesCubit>().clearFilters();
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
        title: const Text('العقارات'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        actions: [
          // Clear filters button
          if (_getActiveFiltersCount() > 0)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearFilters,
              tooltip: 'مسح الفلاتر',
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 600) {
                  return const PropertiesTabletLayout();
                } else {
                  return const PropertiesMobileLayout();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    final activeFiltersCount = _getActiveFiltersCount();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
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
                                _applySearch();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                    onSubmitted: (value) => _applySearch(),
                  ),
                ),
                const SizedBox(width: 8),
                // Advanced filters toggle button
                Container(
                  decoration: BoxDecoration(
                    color: _showAdvancedFilters
                        ? AppColors.primary
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _showAdvancedFilters
                          ? AppColors.primary
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.tune,
                          color: _showAdvancedFilters
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                        onPressed: () {
                          setState(() {
                            _showAdvancedFilters = !_showAdvancedFilters;
                          });
                        },
                        tooltip: 'فلاتر متقدمة',
                      ),
                      if (activeFiltersCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '$activeFiltersCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Search button
                ElevatedButton(
                  onPressed: _applySearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'بحث',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Advanced filters dropdown
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: _buildAdvancedFilters(),
            ),
            crossFadeState: _showAdvancedFilters
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 8),

            // Offer Types
            _buildOfferTypesSection(),
            const SizedBox(height: 16),

            // Property Types
            _buildPropertyTypesSection(),
            const SizedBox(height: 16),

            // Price Range
            _buildPriceRangeSection(),
            const SizedBox(height: 16),

            // Location
            _buildLocationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع العرض',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        BlocBuilder<OfferTypesCubit, OfferTypesState>(
          builder: (context, state) {
            if (state is OfferTypesLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
          builder: (context, state) {
            if (state is PropertyTypesLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'من',
                  hintText: '0',
                  prefixIcon: const Icon(Icons.attach_money, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'إلى',
                  hintText: '∞',
                  prefixIcon: const Icon(Icons.attach_money, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildGovernoratesFilter(),
        if (selectedGovernorateId != null) ...[
          const SizedBox(height: 12),
          _buildDistrictsFilter(),
        ],
        if (selectedDistrictId != null) ...[
          const SizedBox(height: 12),
          _buildNeighborhoodsFilter(),
        ],
      ],
    );
  }

  Widget _buildGovernoratesFilter() {
    return BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        if (state is GovernoratesLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is GovernoratesSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'المحافظة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: state.response.governorates.map((gov) {
                  return GovernorateFilterChip(
                    governorate: gov,
                    isSelected: selectedGovernorateId == gov.id,
                    showDistrictsCount: false,
                    onTap: () {
                      _onGovernorateSelected(
                        selectedGovernorateId == gov.id ? null : gov.id,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDistrictsFilter() {
    return BlocBuilder<DistrictsCubit, DistrictsState>(
      builder: (context, state) {
        if (state is DistrictsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is DistrictsSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'المديرية',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
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
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNeighborhoodsFilter() {
    return BlocBuilder<NeighborhoodsCubit, NeighborhoodsState>(
      builder: (context, state) {
        if (state is NeighborhoodsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is NeighborhoodsSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الحي',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
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
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
