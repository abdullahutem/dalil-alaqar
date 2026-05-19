import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/search_filters_state.dart';

class SearchFiltersCubit extends Cubit<SearchFiltersState> {
  SearchFiltersCubit() : super(const SearchFiltersInitial());

  void updateSearchText(String text) {
    if (state is SearchFiltersUpdated) {
      emit((state as SearchFiltersUpdated).copyWith(searchText: text));
    } else {
      emit(
        SearchFiltersUpdated(
          searchText: text,
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updatePropertyType(int? typeId) {
    if (state is SearchFiltersUpdated) {
      emit(
        (state as SearchFiltersUpdated).copyWith(
          propertyTypeId: typeId,
          clearPropertyType: typeId == null,
        ),
      );
    } else {
      emit(
        SearchFiltersUpdated(
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
    if (state is SearchFiltersUpdated) {
      emit(
        (state as SearchFiltersUpdated).copyWith(
          offerTypeId: typeId,
          clearOfferType: typeId == null,
        ),
      );
    } else {
      emit(
        SearchFiltersUpdated(
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
    if (state is SearchFiltersUpdated) {
      emit(
        (state as SearchFiltersUpdated).copyWith(
          governorateId: governorateId,
          clearGovernorate: governorateId == null,
          clearDistrict: true,
          clearNeighborhood: true,
        ),
      );
    } else {
      emit(
        SearchFiltersUpdated(
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
    if (state is SearchFiltersUpdated) {
      emit(
        (state as SearchFiltersUpdated).copyWith(
          districtId: districtId,
          clearDistrict: districtId == null,
          clearNeighborhood: true,
        ),
      );
    } else {
      emit(
        SearchFiltersUpdated(
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
    if (state is SearchFiltersUpdated) {
      emit(
        (state as SearchFiltersUpdated).copyWith(
          neighborhoodId: neighborhoodId,
          clearNeighborhood: neighborhoodId == null,
        ),
      );
    } else {
      emit(
        SearchFiltersUpdated(
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
    if (state is SearchFiltersUpdated) {
      emit((state as SearchFiltersUpdated).copyWith(minPrice: price));
    } else {
      emit(
        SearchFiltersUpdated(
          searchText: '',
          minPrice: price,
          maxPrice: '',
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void updateMaxPrice(String price) {
    if (state is SearchFiltersUpdated) {
      emit((state as SearchFiltersUpdated).copyWith(maxPrice: price));
    } else {
      emit(
        SearchFiltersUpdated(
          searchText: '',
          minPrice: '',
          maxPrice: price,
          showAdvancedFilters: false,
        ),
      );
    }
  }

  void toggleAdvancedFilters() {
    if (state is SearchFiltersUpdated) {
      emit(
        (state as SearchFiltersUpdated).copyWith(
          showAdvancedFilters: !state.showAdvancedFilters,
        ),
      );
    } else {
      emit(
        const SearchFiltersUpdated(
          searchText: '',
          minPrice: '',
          maxPrice: '',
          showAdvancedFilters: true,
        ),
      );
    }
  }

  void clearAllFilters() {
    emit(const SearchFiltersInitial());
  }
}
