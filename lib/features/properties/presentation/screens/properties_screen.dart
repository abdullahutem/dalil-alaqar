import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/search_filters_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/search_filters_state.dart';
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
  final int? initialPropertyTypeId;
  final int? initialOfferTypeId;
  final int? initialGovernorateId;
  final int? initialDistrictId;
  final int? initialNeighborhoodId;

  const PropertiesScreen({
    super.key,
    this.initialPropertyTypeId,
    this.initialOfferTypeId,
    this.initialGovernorateId,
    this.initialDistrictId,
    this.initialNeighborhoodId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PropertiesCubit.create()
            ..getProperties(
              propertyTypeId: initialPropertyTypeId,
              offerTypeId: initialOfferTypeId,
              governorateId: initialGovernorateId,
              districtId: initialDistrictId,
              neighborhoodId: initialNeighborhoodId,
            ),
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
        BlocProvider(
          create: (context) {
            final cubit = SearchFiltersCubit();
            // Apply initial filters if provided
            if (initialPropertyTypeId != null) {
              cubit.updatePropertyType(initialPropertyTypeId);
            }
            if (initialOfferTypeId != null) {
              cubit.updateOfferType(initialOfferTypeId);
            }
            if (initialGovernorateId != null) {
              cubit.updateGovernorate(initialGovernorateId);
            }
            if (initialDistrictId != null) {
              cubit.updateDistrict(initialDistrictId);
            }
            if (initialNeighborhoodId != null) {
              cubit.updateNeighborhood(initialNeighborhoodId);
            }
            // Show advanced filters if any filter is applied
            if (initialPropertyTypeId != null ||
                initialOfferTypeId != null ||
                initialGovernorateId != null ||
                initialDistrictId != null ||
                initialNeighborhoodId != null) {
              cubit.toggleAdvancedFilters();
            }
            return cubit;
          },
        ),
      ],
      child: _PropertiesScreenContent(
        initialGovernorateId: initialGovernorateId,
        initialDistrictId: initialDistrictId,
      ),
    );
  }
}

class _PropertiesScreenContent extends StatefulWidget {
  final int? initialGovernorateId;
  final int? initialDistrictId;

  const _PropertiesScreenContent({
    this.initialGovernorateId,
    this.initialDistrictId,
  });

  @override
  State<_PropertiesScreenContent> createState() =>
      _PropertiesScreenContentState();
}

class _PropertiesScreenContentState extends State<_PropertiesScreenContent> {
  @override
  void initState() {
    super.initState();
    // Load districts and neighborhoods if initial location filters are provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialGovernorateId != null) {
        context.read<DistrictsCubit>().getDistrictsByGovernorate(
          widget.initialGovernorateId!,
        );
      }
      if (widget.initialDistrictId != null) {
        context.read<NeighborhoodsCubit>().getNeighborhoodsByDistrict(
          widget.initialDistrictId!,
        );
      }
    });
  }

  void _applySearch(BuildContext context) {
    final filtersState = context.read<SearchFiltersCubit>().state;

    context.read<PropertiesCubit>().getProperties(
      refresh: true,
      search: filtersState.searchText.isNotEmpty
          ? filtersState.searchText
          : null,
      propertyTypeId: filtersState.propertyTypeId,
      offerTypeId: filtersState.offerTypeId,
      governorateId: filtersState.governorateId,
      districtId: filtersState.districtId,
      neighborhoodId: filtersState.neighborhoodId,
      minPrice: filtersState.minPrice.isNotEmpty
          ? double.tryParse(filtersState.minPrice)
          : null,
      maxPrice: filtersState.maxPrice.isNotEmpty
          ? double.tryParse(filtersState.maxPrice)
          : null,
    );
  }

  void _clearFilters(BuildContext context) {
    context.read<SearchFiltersCubit>().clearAllFilters();
    context.read<DistrictsCubit>().clearDistricts();
    context.read<NeighborhoodsCubit>().clearNeighborhoods();
    context.read<PropertiesCubit>().clearFilters();
  }

  void _onGovernorateSelected(BuildContext context, int? governorateId) {
    context.read<SearchFiltersCubit>().updateGovernorate(governorateId);

    if (governorateId != null) {
      context.read<DistrictsCubit>().getDistrictsByGovernorate(governorateId);
    } else {
      context.read<DistrictsCubit>().clearDistricts();
    }
    context.read<NeighborhoodsCubit>().clearNeighborhoods();
  }

  void _onDistrictSelected(BuildContext context, int? districtId) {
    context.read<SearchFiltersCubit>().updateDistrict(districtId);

    if (districtId != null) {
      context.read<NeighborhoodsCubit>().getNeighborhoodsByDistrict(districtId);
    } else {
      context.read<NeighborhoodsCubit>().clearNeighborhoods();
    }
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
          BlocBuilder<SearchFiltersCubit, SearchFiltersState>(
            builder: (context, state) {
              if (state.activeFiltersCount > 0) {
                return IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () => _clearFilters(context),
                  tooltip: 'مسح الفلاتر',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(context),
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

  Widget _buildSearchSection(BuildContext context) {
    return BlocBuilder<SearchFiltersCubit, SearchFiltersState>(
      builder: (context, filtersState) {
        return Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: filtersState.searchText)
                              ..selection = TextSelection.collapsed(
                                offset: filtersState.searchText.length,
                              ),
                        decoration: InputDecoration(
                          hintText: 'ابحث عن عقار...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: filtersState.searchText.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    context
                                        .read<SearchFiltersCubit>()
                                        .updateSearchText('');
                                    _applySearch(context);
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
                        onChanged: (value) {
                          context.read<SearchFiltersCubit>().updateSearchText(
                            value,
                          );
                        },
                        onSubmitted: (value) => _applySearch(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Advanced filters toggle button
                    Container(
                      decoration: BoxDecoration(
                        color: filtersState.showAdvancedFilters
                            ? AppColors.primary
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: filtersState.showAdvancedFilters
                              ? AppColors.primary
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.tune,
                              color: filtersState.showAdvancedFilters
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            onPressed: () {
                              context
                                  .read<SearchFiltersCubit>()
                                  .toggleAdvancedFilters();
                            },
                            tooltip: 'فلاتر متقدمة',
                          ),
                          if (filtersState.activeFiltersCount > 0)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${filtersState.activeFiltersCount}',
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
                      onPressed: () => _applySearch(context),
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
                  child: _buildAdvancedFilters(context),
                ),
                crossFadeState: filtersState.showAdvancedFilters
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdvancedFilters(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 8),

            // Offer Types
            _buildOfferTypesSection(context),
            const SizedBox(height: 16),

            // Property Types
            _buildPropertyTypesSection(context),
            const SizedBox(height: 16),

            // Price Range
            _buildPriceRangeSection(context),
            const SizedBox(height: 16),

            // Location
            _buildLocationSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferTypesSection(BuildContext context) {
    return BlocBuilder<SearchFiltersCubit, SearchFiltersState>(
      builder: (context, filtersState) {
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
                        isSelected: filtersState.offerTypeId == type.id,
                        onTap: () {
                          context.read<SearchFiltersCubit>().updateOfferType(
                            filtersState.offerTypeId == type.id
                                ? null
                                : type.id,
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
      },
    );
  }

  Widget _buildPropertyTypesSection(BuildContext context) {
    return BlocBuilder<SearchFiltersCubit, SearchFiltersState>(
      builder: (context, filtersState) {
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
                        isSelected: filtersState.propertyTypeId == type.id,
                        onTap: () {
                          context.read<SearchFiltersCubit>().updatePropertyType(
                            filtersState.propertyTypeId == type.id
                                ? null
                                : type.id,
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
      },
    );
  }

  Widget _buildPriceRangeSection(BuildContext context) {
    return BlocBuilder<SearchFiltersCubit, SearchFiltersState>(
      builder: (context, filtersState) {
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
                    controller:
                        TextEditingController(text: filtersState.minPrice)
                          ..selection = TextSelection.collapsed(
                            offset: filtersState.minPrice.length,
                          ),
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
                    onChanged: (value) {
                      context.read<SearchFiltersCubit>().updateMinPrice(value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller:
                        TextEditingController(text: filtersState.maxPrice)
                          ..selection = TextSelection.collapsed(
                            offset: filtersState.maxPrice.length,
                          ),
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
                    onChanged: (value) {
                      context.read<SearchFiltersCubit>().updateMaxPrice(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return BlocBuilder<SearchFiltersCubit, SearchFiltersState>(
      builder: (context, filtersState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الموقع',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildGovernoratesFilter(context, filtersState),
            if (filtersState.governorateId != null) ...[
              const SizedBox(height: 12),
              _buildDistrictsFilter(context, filtersState),
            ],
            if (filtersState.districtId != null) ...[
              const SizedBox(height: 12),
              _buildNeighborhoodsFilter(context, filtersState),
            ],
          ],
        );
      },
    );
  }

  Widget _buildGovernoratesFilter(
    BuildContext context,
    SearchFiltersState filtersState,
  ) {
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
                    isSelected: filtersState.governorateId == gov.id,
                    showDistrictsCount: false,
                    onTap: () {
                      _onGovernorateSelected(
                        context,
                        filtersState.governorateId == gov.id ? null : gov.id,
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

  Widget _buildDistrictsFilter(
    BuildContext context,
    SearchFiltersState filtersState,
  ) {
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
                    isSelected: filtersState.districtId == district.id,
                    onTap: () {
                      _onDistrictSelected(
                        context,
                        filtersState.districtId == district.id
                            ? null
                            : district.id,
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

  Widget _buildNeighborhoodsFilter(
    BuildContext context,
    SearchFiltersState filtersState,
  ) {
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
                    isSelected: filtersState.neighborhoodId == neighborhood.id,
                    onTap: () {
                      context.read<SearchFiltersCubit>().updateNeighborhood(
                        filtersState.neighborhoodId == neighborhood.id
                            ? null
                            : neighborhood.id,
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
}
