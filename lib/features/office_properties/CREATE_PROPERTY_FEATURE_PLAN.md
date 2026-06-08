# Create Property Feature - Implementation Plan

## Overview
Implement a comprehensive property creation feature for office users to add new properties with all details including location selection via interactive map.

## API Endpoint
```
POST office/properties
Content-Type: application/json
```

### Request Body
```json
{
  "property_type_id": 2,
  "offer_type_id": 2,
  "title": "فيلا فاخرة للإيجار في حدة",
  "description": "فيلا دورين، 300 متر، 5 غرف نوم، 4 حمامات، صالتين، مطبخ كبير، حديقة، موقف سيارات",
  "price": 200000,
  "price_negotiable": false,
  "governorate_id": 8,
  "district_id": 47,
  "neighborhood_id": 103,
  "address": "شارع الستين، حدة، صنعاء",
  "latitude": 15.3694,
  "longitude": 44.1910,
  "currency_id": 1,
  "status": "available"
}
```

### Response
```json
{
  "success": true,
  "message": "تم إضافة العقار بنجاح",
  "data": {
    "id": 103,
    "title": "فيلا فاخرة للإيجار في حدة",
    "reference_number": "AQ-2026-093",
    ...
  }
}
```

## Architecture Overview

### Clean Architecture Layers

#### 1. Domain Layer
- **Entity**: `CreatePropertyEntity` (request data)
- **UseCase**: `CreatePropertyUseCase`
- **Repository Interface**: `createProperty()` method

#### 2. Data Layer
- **Model**: `CreatePropertyModel` extends `CreatePropertyEntity`
- **Request Model**: Serialization to JSON
- **Data Source**: Add `createProperty()` to remote data source
- **Repository Implementation**: Network check + error handling

#### 3. Presentation Layer
- **Cubit**: `CreatePropertyCubit` with states
- **Screen**: Multi-step form with map integration
- **Widgets**: Reusable form components

## Implementation Steps

### Phase 1: Backend Integration (Data & Domain)

1. **Create Entity**
   ```dart
   class CreatePropertyEntity {
     final int propertyTypeId;
     final int offerTypeId;
     final String title;
     final String description;
     final double price;
     final bool priceNegotiable;
     final int governorateId;
     final int districtId;
     final int neighborhoodId;
     final String address;
     final double latitude;
     final double longitude;
     final int currencyId;
     final String status;
   }
   ```

2. **Create Model** with `toJson()` method

3. **Add to Data Source**
   ```dart
   Future<PropertyDetailsResponseModel> createProperty({
     required CreatePropertyModel property,
   });
   ```

4. **Add to Repository Interface & Implementation**

5. **Create UseCase**
   ```dart
   class CreatePropertyUseCase {
     Future<Either<Failure, PropertyDetailsResponseEntity>> call({
       required CreatePropertyEntity property,
     });
   }
   ```

### Phase 2: State Management

1. **Create States**
   ```dart
   CreatePropertyInitial
   CreatePropertyLoading
   CreatePropertySuccess(PropertyDetailsEntity)
   CreatePropertyError(String message)
   CreatePropertyValidationError(Map<String, String> errors)
   ```

2. **Create Cubit**
   ```dart
   class CreatePropertyCubit extends Cubit<CreatePropertyState> {
     Future<void> createProperty(CreatePropertyEntity property);
     void validateForm();
     void resetForm();
   }
   ```

### Phase 3: UI/UX Implementation

#### Screen Structure
```
Scaffold
├── AppBar ("إضافة عقار جديد")
├── Body (Stepper or PageView)
│   ├── Step 1: Basic Information
│   │   ├── Property Type Dropdown
│   │   ├── Offer Type Dropdown
│   │   ├── Title TextField
│   │   ├── Description TextField (multiline)
│   │   └── Next Button
│   │
│   ├── Step 2: Price & Currency
│   │   ├── Price TextField (numeric)
│   │   ├── Currency Dropdown
│   │   ├── Price Negotiable Checkbox
│   │   └── Next Button
│   │
│   ├── Step 3: Location Selection
│   │   ├── Interactive Map (flutter_map)
│   │   │   ├── Tap to select location
│   │   │   ├── My Location button
│   │   │   └── Zoom controls
│   │   ├── Address TextField (auto-filled)
│   │   ├── Governorate Dropdown
│   │   ├── District Dropdown (cascading)
│   │   ├── Neighborhood Dropdown (cascading)
│   │   └── Next Button
│   │
│   └── Step 4: Review & Submit
│       ├── Summary Card
│       │   ├── All entered information
│       │   ├── Map preview
│       │   └── Edit buttons for each section
│       └── Submit Button
└── Bottom Navigation
    ├── Back Button
    ├── Step Indicator
    └── Next/Submit Button
```

#### Key UI Components

1. **Property Type & Offer Type Dropdowns**
   - Fetch from existing dropdowns cubits
   - Use existing `PropertyType` and `OfferType` entities
   - Required validation

2. **Form Fields**
   - Title: Required, max 200 characters
   - Description: Required, multiline (3-5 lines), max 1000 characters
   - Price: Required, numeric, > 0
   - Currency: Dropdown (default to 1 - YER)
   - Price Negotiable: Checkbox (default false)

3. **Map Integration** (Use map_location_implementation_prompt.md)
   - Interactive map with OpenStreetMap tiles
   - Tap to select location
   - Reverse geocoding for address
   - Location permission handling
   - My location button
   - Marker at selected position

4. **Geographic Cascading Dropdowns**
   - Governorate → District → Neighborhood
   - Use existing cubits:
     - `GovernoratesCubit`
     - `DistrictsCubit` (filtered by governorate)
     - `NeighborhoodsCubit` (filtered by district)
   - Reset child dropdowns when parent changes

5. **Status Selection**
   - Default to "available"
   - Options: available, rented, sold (if needed)

### Phase 4: Form Validation

```dart
class PropertyFormValidator {
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
    return null;
  }

  static String? validateCoordinates(double? lat, double? lon) {
    if (lat == null || lon == null) {
      return 'الرجاء تحديد الموقع على الخريطة';
    }
    if (lat < -90 || lat > 90) {
      return 'خط العرض غير صحيح';
    }
    if (lon < -180 || lon > 180) {
      return 'خط الطول غير صحيح';
    }
    return null;
  }

  static bool validateGeographicSelection({
    int? governorateId,
    int? districtId,
    int? neighborhoodId,
  }) {
    return governorateId != null && 
           districtId != null && 
           neighborhoodId != null;
  }
}
```

### Phase 5: Map Integration

Following `map_location_implementation_prompt.md`:

1. **Dependencies**
   ```yaml
   flutter_map: ^7.0.2
   latlong2: ^0.9.1
   geolocator: ^13.0.2
   ```

2. **Location Cubit** (simplified for property creation)
   ```dart
   class PropertyLocationCubit extends Cubit<PropertyLocationState> {
     LatLng currentPosition = const LatLng(15.3694, 44.1910); // Sana'a default
     String? currentAddress;
     
     Future<void> updateMapPosition(LatLng position);
     Future<void> requestLocationPermission();
     Future<void> _reverseGeocode(LatLng position);
   }
   ```

3. **Map Widget**
   - FlutterMap with OpenStreetMap tiles
   - Marker at selected position
   - Tap handler to update position
   - Control buttons (zoom, my location)
   - Auto-fill address field from reverse geocoding

4. **Permission Handling**
   - Request location permission
   - Fallback to default Yemen coordinates
   - Show permission denied message

### Phase 6: User Flow

1. **Access Point**
   - Floating Action Button on properties list screen
   - Icon: `Icons.add`
   - Label: "إضافة عقار"

2. **Step-by-Step Flow**
   ```
   Start → Basic Info → Price → Location → Review → Submit → Success
   ```

3. **Navigation**
   - Back button: Go to previous step
   - Next button: Validate current step then proceed
   - Cancel button: Show confirmation dialog
   - Submit button: Validate all + API call

4. **After Success**
   - Show success message
   - Navigate to property details screen of created property
   - Refresh properties list

### Phase 7: Error Handling

1. **Validation Errors**
   - Show inline errors on form fields
   - Highlight invalid steps
   - Prevent navigation to next step

2. **Network Errors**
   - Show SnackBar with error message
   - Keep form data
   - Allow retry

3. **Permission Errors**
   - Show message about location permission
   - Provide button to app settings
   - Allow manual coordinate entry

## Files to Create/Modify

### New Files (Minimum 15 files)

**Domain Layer:**
1. `domain/entities/create_property_entity.dart`
2. `domain/usecases/create_property_usecase.dart`

**Data Layer:**
3. `data/models/create_property_model.dart`

**Presentation Layer:**
4. `presentation/cubit/create_property_cubit.dart`
5. `presentation/cubit/create_property_state.dart`
6. `presentation/cubit/property_location_cubit.dart`
7. `presentation/cubit/property_location_state.dart`
8. `presentation/screens/create_property_screen.dart`
9. `presentation/widgets/basic_info_step.dart`
10. `presentation/widgets/price_step.dart`
11. `presentation/widgets/location_step.dart`
12. `presentation/widgets/review_step.dart`
13. `presentation/widgets/property_map_picker.dart`
14. `presentation/widgets/property_form_field.dart`
15. `presentation/utils/property_form_validator.dart`

### Modified Files
1. `data/datasources/office_properties_remote_data_source.dart` - Add createProperty
2. `domain/repositories/office_properties_repository.dart` - Add interface
3. `data/repositories/office_properties_repository_impl.dart` - Implement
4. `core/databases/api/end_points.dart` - Add endpoint
5. `presentation/screens/office_properties_screen.dart` - Add FAB

## Dependencies Check

Required packages (check if installed):
```yaml
flutter_map: ^7.0.2          # For map
latlong2: ^0.9.1             # For coordinates
geolocator: ^13.0.2          # For location permissions
dio: ^5.x.x                  # For reverse geocoding (already installed)
flutter_bloc: ^8.x.x         # State management (already installed)
```

## Testing Checklist

- [ ] Create property with all required fields
- [ ] Validation for each field
- [ ] Map tap updates coordinates
- [ ] Reverse geocoding fills address
- [ ] Location permission flow
- [ ] Cascading dropdowns work correctly
- [ ] Price negotiable checkbox
- [ ] Form reset functionality
- [ ] Step navigation (back/next)
- [ ] Submit creates property successfully
- [ ] Navigate to details after creation
- [ ] Error handling for network failures
- [ ] Error handling for validation failures
- [ ] Offline behavior
- [ ] RTL support for Arabic

## UI/UX Guidelines

### Design Consistency
- Use existing color scheme and typography
- Follow material design principles
- Maintain RTL layout for Arabic
- Use existing reusable widgets where possible

### Accessibility
- Loading indicators during API calls
- Clear error messages in Arabic
- Disabled states for invalid forms
- Progress indicator for multi-step form

### User Feedback
- Success SnackBar after creation
- Error SnackBars with retry options
- Loading state on submit button
- Confirmation dialog on cancel

## Next Steps

1. **Phase 1**: Implement backend integration (data + domain layers)
2. **Phase 2**: Create state management (cubits + states)
3. **Phase 3**: Build basic form UI (without map)
4. **Phase 4**: Integrate map functionality
5. **Phase 5**: Add validation and error handling
6. **Phase 6**: Polish UI/UX and testing
7. **Phase 7**: Integration with existing screens

## Estimated Complexity

- **Backend Integration**: Medium (similar to existing features)
- **Form UI**: Medium (multiple steps, many fields)
- **Map Integration**: High (location permissions, reverse geocoding)
- **Validation**: Medium (comprehensive validation logic)
- **Overall**: High Complexity Feature

**Recommended Approach**: Implement in phases, test each phase thoroughly before moving to the next.

## Notes

- Property is created WITHOUT images initially
- After creation, user can use "Upload Multiple Images" feature
- Reference number is auto-generated by backend
- Created_by is automatically set from authenticated user
- Status defaults to "available"
- Currency defaults to 1 (YER - Yemeni Rial)

## Future Enhancements

- Draft save functionality
- Image upload in creation flow
- Property templates
- Bulk property creation
- Copy from existing property
- More detailed property attributes (rooms, bathrooms, area, etc.)
