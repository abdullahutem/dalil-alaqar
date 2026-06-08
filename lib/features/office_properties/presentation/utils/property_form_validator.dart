class PropertyFormValidator {
  /// Validates property title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'العنوان مطلوب';
    }
    if (value.trim().length < 10) {
      return 'العنوان يجب أن يكون 10 أحرف على الأقل';
    }
    if (value.length > 200) {
      return 'العنوان يجب ألا يزيد عن 200 حرف';
    }
    return null;
  }

  /// Validates property description
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الوصف مطلوب';
    }
    if (value.trim().length < 20) {
      return 'الوصف يجب أن يكون 20 حرف على الأقل';
    }
    if (value.length > 1000) {
      return 'الوصف يجب ألا يزيد عن 1000 حرف';
    }
    return null;
  }

  /// Validates property price
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'السعر مطلوب';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'السعر يجب أن يكون رقماً';
    }
    if (price <= 0) {
      return 'السعر يجب أن يكون أكبر من صفر';
    }
    if (price > 999999999) {
      return 'السعر كبير جداً';
    }
    return null;
  }

  /// Validates address
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'العنوان مطلوب';
    }
    if (value.trim().length < 10) {
      return 'العنوان يجب أن يكون 10 أحرف على الأقل';
    }
    return null;
  }

  /// Validates latitude coordinate
  static String? validateLatitude(double? value) {
    if (value == null) {
      return 'خط العرض مطلوب';
    }
    if (value < -90 || value > 90) {
      return 'خط العرض يجب أن يكون بين -90 و 90';
    }
    return null;
  }

  /// Validates longitude coordinate
  static String? validateLongitude(double? value) {
    if (value == null) {
      return 'خط الطول مطلوب';
    }
    if (value < -180 || value > 180) {
      return 'خط الطول يجب أن يكون بين -180 و 180';
    }
    return null;
  }

  /// Validates coordinates (both lat and lon)
  static String? validateCoordinates(double? lat, double? lon) {
    final latError = validateLatitude(lat);
    if (latError != null) return latError;

    final lonError = validateLongitude(lon);
    if (lonError != null) return lonError;

    return null;
  }

  /// Validates dropdown selection (generic)
  static String? validateDropdown(int? value, String fieldName) {
    if (value == null || value <= 0) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  /// Validates property type selection
  static String? validatePropertyType(int? value) {
    return validateDropdown(value, 'نوع العقار');
  }

  /// Validates offer type selection
  static String? validateOfferType(int? value) {
    return validateDropdown(value, 'نوع العرض');
  }

  /// Validates governorate selection
  static String? validateGovernorate(int? value) {
    return validateDropdown(value, 'المحافظة');
  }

  /// Validates district selection
  static String? validateDistrict(int? value) {
    return validateDropdown(value, 'المديرية');
  }

  /// Validates neighborhood selection
  static String? validateNeighborhood(int? value) {
    return validateDropdown(value, 'الحي');
  }

  /// Validates all geographic selections together
  static bool validateGeographicSelection({
    int? governorateId,
    int? districtId,
    int? neighborhoodId,
  }) {
    return governorateId != null &&
        governorateId > 0 &&
        districtId != null &&
        districtId > 0 &&
        neighborhoodId != null &&
        neighborhoodId > 0;
  }

  /// Get error message for invalid geographic selection
  static String getGeographicSelectionError({
    int? governorateId,
    int? districtId,
    int? neighborhoodId,
  }) {
    if (governorateId == null || governorateId <= 0) {
      return 'الرجاء اختيار المحافظة';
    }
    if (districtId == null || districtId <= 0) {
      return 'الرجاء اختيار المديرية';
    }
    if (neighborhoodId == null || neighborhoodId <= 0) {
      return 'الرجاء اختيار الحي';
    }
    return '';
  }
}
