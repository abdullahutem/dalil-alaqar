abstract class SearchFiltersState {
  final String searchText;
  final int? propertyTypeId;
  final int? offerTypeId;
  final int? governorateId;
  final int? districtId;
  final int? neighborhoodId;
  final String minPrice;
  final String maxPrice;
  final bool showAdvancedFilters;

  const SearchFiltersState({
    required this.searchText,
    this.propertyTypeId,
    this.offerTypeId,
    this.governorateId,
    this.districtId,
    this.neighborhoodId,
    required this.minPrice,
    required this.maxPrice,
    required this.showAdvancedFilters,
  });

  int get activeFiltersCount {
    int count = 0;
    if (searchText.isNotEmpty) count++;
    if (propertyTypeId != null) count++;
    if (offerTypeId != null) count++;
    if (governorateId != null) count++;
    if (districtId != null) count++;
    if (neighborhoodId != null) count++;
    if (minPrice.isNotEmpty) count++;
    if (maxPrice.isNotEmpty) count++;
    return count;
  }
}

class SearchFiltersInitial extends SearchFiltersState {
  const SearchFiltersInitial()
    : super(
        searchText: '',
        minPrice: '',
        maxPrice: '',
        showAdvancedFilters: false,
      );
}

class SearchFiltersUpdated extends SearchFiltersState {
  const SearchFiltersUpdated({
    required super.searchText,
    super.propertyTypeId,
    super.offerTypeId,
    super.governorateId,
    super.districtId,
    super.neighborhoodId,
    required super.minPrice,
    required super.maxPrice,
    required super.showAdvancedFilters,
  });

  SearchFiltersUpdated copyWith({
    String? searchText,
    int? propertyTypeId,
    bool clearPropertyType = false,
    int? offerTypeId,
    bool clearOfferType = false,
    int? governorateId,
    bool clearGovernorate = false,
    int? districtId,
    bool clearDistrict = false,
    int? neighborhoodId,
    bool clearNeighborhood = false,
    String? minPrice,
    String? maxPrice,
    bool? showAdvancedFilters,
  }) {
    return SearchFiltersUpdated(
      searchText: searchText ?? this.searchText,
      propertyTypeId: clearPropertyType
          ? null
          : (propertyTypeId ?? this.propertyTypeId),
      offerTypeId: clearOfferType ? null : (offerTypeId ?? this.offerTypeId),
      governorateId: clearGovernorate
          ? null
          : (governorateId ?? this.governorateId),
      districtId: clearDistrict ? null : (districtId ?? this.districtId),
      neighborhoodId: clearNeighborhood
          ? null
          : (neighborhoodId ?? this.neighborhoodId),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      showAdvancedFilters: showAdvancedFilters ?? this.showAdvancedFilters,
    );
  }
}
