import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../governorates/domain/entities/governorate_entity.dart';
import '../../../governorates/presentation/cubit/governorates_cubit.dart';
import '../../../governorates/presentation/cubit/governorates_state.dart';
import '../../../districts/domain/entities/district_entity.dart';
import '../../../districts/presentation/cubit/districts_cubit.dart';
import '../../../districts/presentation/cubit/districts_state.dart';
import '../../../neighborhoods/domain/entities/neighborhood_entity.dart';
import '../../../neighborhoods/presentation/cubit/neighborhoods_cubit.dart';
import '../../../neighborhoods/presentation/cubit/neighborhoods_state.dart';

class GeographicSelectionWidget extends StatefulWidget {
  final GovernorateEntity? selectedGovernorate;
  final DistrictEntity? selectedDistrict;
  final NeighborhoodEntity? selectedNeighborhood;
  final Function(GovernorateEntity?) onGovernorateChanged;
  final Function(DistrictEntity?) onDistrictChanged;
  final Function(NeighborhoodEntity?) onNeighborhoodChanged;
  final bool isDark;
  const GeographicSelectionWidget({
    super.key,
    this.selectedGovernorate,
    this.selectedDistrict,
    this.selectedNeighborhood,
    required this.onGovernorateChanged,
    required this.onDistrictChanged,
    required this.onNeighborhoodChanged,
    required this.isDark,
  });

  @override
  State<GeographicSelectionWidget> createState() =>
      _GeographicSelectionWidgetState();
}

class _GeographicSelectionWidgetState extends State<GeographicSelectionWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GovernoratesCubit>().getGovernorates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Governorate Dropdown
        BlocBuilder<GovernoratesCubit, GovernoratesState>(
          builder: (context, state) {
            if (state is GovernoratesLoading) {
              return _buildLoadingDropdown('المحافظة', widget.isDark);
            }
            if (state is GovernoratesError) {
              return _buildErrorDropdown(
                'المحافظة',
                state.message,
                widget.isDark,
              );
            }
            if (state is GovernoratesSuccess) {
              final governorates = state.response.governorates;
              return _buildGovernorateDropdown(governorates, widget.isDark);
            }
            return _buildLoadingDropdown('المحافظة', widget.isDark);
          },
        ),

        const SizedBox(height: 16),

        // District Dropdown
        BlocBuilder<DistrictsCubit, DistrictsState>(
          builder: (context, state) {
            if (widget.selectedGovernorate == null) {
              return _buildDisabledDropdown('المديرية', widget.isDark);
            }
            if (state is DistrictsLoading) {
              return _buildLoadingDropdown('المديرية', widget.isDark);
            }
            if (state is DistrictsError) {
              return _buildErrorDropdown(
                'المديرية',
                state.message,
                widget.isDark,
              );
            }
            if (state is DistrictsSuccess) {
              final districts = state.response.districts;
              return _buildDistrictDropdown(districts, widget.isDark);
            }
            return _buildDisabledDropdown('المديرية', widget.isDark);
          },
        ),

        const SizedBox(height: 16),

        // Neighborhood Dropdown
        BlocBuilder<NeighborhoodsCubit, NeighborhoodsState>(
          builder: (context, state) {
            if (widget.selectedDistrict == null) {
              return _buildDisabledDropdown('الحي', widget.isDark);
            }
            if (state is NeighborhoodsLoading) {
              return _buildLoadingDropdown('الحي', widget.isDark);
            }
            if (state is NeighborhoodsError) {
              return _buildErrorDropdown('الحي', state.message, widget.isDark);
            }
            if (state is NeighborhoodsSuccess) {
              final neighborhoods = state.response.neighborhoods;
              return _buildNeighborhoodDropdown(neighborhoods, widget.isDark);
            }
            return _buildDisabledDropdown('الحي', widget.isDark);
          },
        ),
      ],
    );
  }

  Widget _buildGovernorateDropdown(
    List<GovernorateEntity> governorates,
    bool isDark,
  ) {
    return DropdownButtonFormField<GovernorateEntity>(
      initialValue: widget.selectedGovernorate,
      decoration: InputDecoration(
        labelText: 'المحافظة',
        prefixIcon: const Icon(Icons.location_city),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: governorates.map((governorate) {
        return DropdownMenuItem<GovernorateEntity>(
          value: governorate,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              governorate.nameAr,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        widget.onGovernorateChanged(value);
        if (value != null) {
          context.read<DistrictsCubit>().getDistrictsByGovernorate(value.id);
          context.read<NeighborhoodsCubit>().clearNeighborhoods();
          widget.onDistrictChanged(null);
          widget.onNeighborhoodChanged(null);
        }
      },
      validator: (value) {
        if (value == null) {
          return 'الرجاء اختيار المحافظة';
        }
        return null;
      },
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  Widget _buildDistrictDropdown(List<DistrictEntity> districts, bool isDark) {
    return DropdownButtonFormField<DistrictEntity>(
      initialValue: widget.selectedDistrict,
      decoration: InputDecoration(
        labelText: 'المديرية',
        prefixIcon: const Icon(Icons.map),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: districts.map((district) {
        return DropdownMenuItem<DistrictEntity>(
          value: district,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              district.nameAr,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        widget.onDistrictChanged(value);
        if (value != null) {
          context.read<NeighborhoodsCubit>().getNeighborhoodsByDistrict(
            value.id,
          );
          widget.onNeighborhoodChanged(null);
        }
      },
      validator: (value) {
        if (value == null) {
          return 'الرجاء اختيار المديرية';
        }
        return null;
      },
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  Widget _buildNeighborhoodDropdown(
    List<NeighborhoodEntity> neighborhoods,
    bool isDark,
  ) {
    return DropdownButtonFormField<NeighborhoodEntity>(
      initialValue: widget.selectedNeighborhood,
      decoration: InputDecoration(
        labelText: 'الحي',
        prefixIcon: const Icon(Icons.place),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: neighborhoods.map((neighborhood) {
        return DropdownMenuItem<NeighborhoodEntity>(
          value: neighborhood,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              neighborhood.nameAr,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      onChanged: widget.onNeighborhoodChanged,
      validator: (value) {
        if (value == null) {
          return 'الرجاء اختيار الحي';
        }
        return null;
      },
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  Widget _buildLoadingDropdown(String label, bool isDark) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: const [],
      onChanged: null,
    );
  }

  Widget _buildDisabledDropdown(String label, bool isDark) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: const [],
      onChanged: null,
      disabledHint: const Align(
        alignment: Alignment.centerRight,
        child: Text(
          'اختر الخيار السابق أولاً',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildErrorDropdown(String label, String error, bool isDark) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.error, color: Colors.red),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: const [],
      onChanged: null,
      disabledHint: Align(
        alignment: Alignment.centerRight,
        child: Text(
          error,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
      ),
    );
  }
}
