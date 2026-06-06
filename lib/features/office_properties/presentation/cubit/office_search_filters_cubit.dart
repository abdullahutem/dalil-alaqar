import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/office_properties/presentation/cubit/office_search_filters_state.dart';

class OfficeSearchFiltersCubit extends Cubit<OfficeSearchFiltersState> {
  OfficeSearchFiltersCubit() : super(const OfficeSearchFiltersInitial());

  void updateSearchText(String text) {
    if (state is OfficeSearchFiltersUpdated) {
      emit((state as OfficeSearchFiltersUpdated).copyWith(searchText: text));
    } else {
      emit(
        OfficeSearchFiltersUpdated(
          searchText: text,
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updatePropertyType(int? typeId) {
    if (state is OfficeSearchFiltersUpdated) {
      emit(
        (state as OfficeSearchFiltersUpdated).copyWith(
          propertyTypeId: typeId,
          clearPropertyType: typeId == null,
        ),
      );
    } else {
      emit(
        OfficeSearchFiltersUpdated(
          searchText: '',
          propertyTypeId: typeId,
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updateOfferType(int? typeId) {
    if (state is OfficeSearchFiltersUpdated) {
      emit(
        (state as OfficeSearchFiltersUpdated).copyWith(
          offerTypeId: typeId,
          clearOfferType: typeId == null,
        ),
      );
    } else {
      emit(
        OfficeSearchFiltersUpdated(
          searchText: '',
          offerTypeId: typeId,
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updateGovernorate(int? governorateId) {
    if (state is OfficeSearchFiltersUpdated) {
      emit(
        (state as OfficeSearchFiltersUpdated).copyWith(
          governorateId: governorateId,
          clearGovernorate: governorateId == null,
          clearDistrict: true,
          clearNeighborhood: true,
        ),
      );
    } else {
      emit(
        OfficeSearchFiltersUpdated(
          searchText: '',
          governorateId: governorateId,
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updateDistrict(int? districtId) {
    if (state is OfficeSearchFiltersUpdated) {
      emit(
        (state as OfficeSearchFiltersUpdated).copyWith(
          districtId: districtId,
          clearDistrict: districtId == null,
          clearNeighborhood: true,
        ),
      );
    } else {
      emit(
        OfficeSearchFiltersUpdated(
          searchText: '',
          districtId: districtId,
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updateNeighborhood(int? neighborhoodId) {
    if (state is OfficeSearchFiltersUpdated) {
      emit(
        (state as OfficeSearchFiltersUpdated).copyWith(
          neighborhoodId: neighborhoodId,
          clearNeighborhood: neighborhoodId == null,
        ),
      );
    } else {
      emit(
        OfficeSearchFiltersUpdated(
          searchText: '',
          neighborhoodId: neighborhoodId,
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updateMinPrice(String price) {
    if (state is OfficeSearchFiltersUpdated) {
      emit((state as OfficeSearchFiltersUpdated).copyWith(minPrice: price));
    } else {
      emit(
        OfficeSearchFiltersUpdated(
          searchText: '',
          minPrice: price,
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updateMaxPrice(String price) {
    if (state is OfficeSearchFiltersUpdated) {
      emit((state as OfficeSearchFiltersUpdated).copyWith(maxPrice: price));
    } else {
      emit(
        OfficeSearchFiltersUpdated(
          searchText: '',
          minPrice: '',
          maxPrice: price,
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void toggleAdvancedFilters() {
    if (state is OfficeSearchFiltersUpdated) {
      emit(
        (state as OfficeSearchFiltersUpdated).copyWith(
          showAdvancedFilters: !state.showAdvancedFilters,
        ),
      );
    } else {
      emit(
        const OfficeSearchFiltersUpdated(
          searchText: '',
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: true,
        ),
      );
    }
  }

  void clearAllFilters() {
    emit(const OfficeSearchFiltersInitial());
  }
}
