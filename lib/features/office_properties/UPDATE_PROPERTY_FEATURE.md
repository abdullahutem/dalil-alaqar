# Update Property Feature

## Overview
This feature allows office users to update existing property information in the system. The implementation follows clean architecture principles with separation of concerns across data, domain, and presentation layers.

## API Endpoint

### Update Property
- **Endpoint**: `PUT /office/properties/{id}`
- **Method**: PUT
- **Authentication**: Required (office user)

#### Request Body
```json
{
  "title": "شقة للبيع في صنعاء - محدث",
  "property_type_id": 2,
  "offer_type_id": 2,
  "description": "فيلا دورين، 300 متر، 5 غرف نوم، 4 حمامات، صالتين، مطبخ كبير، حديقة، موقف سيارات",
  "governorate_id": 1,
  "price": 55000000
}
```

**Note**: Only send fields that need to be updated. All fields are optional except the property ID in the URL.

#### Response
```json
{
  "success": true,
  "message": "تم تحديث العقار بنجاح",
  "data": {
    "id": 107,
    "office_id": 11,
    "property_type_id": 2,
    "offer_type_id": 2,
    "title": "شقة للبيع في صنعاء - محدث",
    "description": "...",
    "price": 55000000,
    "governorate_id": 1,
    // ... other property fields
  }
}
```

## Architecture

### Data Layer

#### 1. Entity (`update_property_entity.dart`)
```dart
class UpdatePropertyEntity {
  final int propertyId;
  final String? title;
  final int? propertyTypeId;
  final int? offerTypeId;
  final String? description;
  final int? governorateId;
  final double? price;
}
```

#### 2. Model (`update_property_model.dart`)
- Extends `UpdatePropertyEntity`
- Provides `toJson()` method for API requests
- Only includes non-null fields in the JSON output
- Implements `fromEntity()` factory constructor

#### 3. Remote Data Source (`office_properties_remote_data_source.dart`)
```dart
Future<PropertyDetailsResponseModel> updateProperty({
  required int propertyId,
  required Map<String, dynamic> data,
});
```

#### 4. Repository Implementation (`office_properties_repository_impl.dart`)
- Implements network connectivity check
- Handles errors and converts to failures
- Converts entity to model before sending to data source

### Domain Layer

#### 1. Repository Interface (`office_properties_repository.dart`)
```dart
Future<Either<Failure, PropertyDetailsResponseEntity>> updateProperty({
  required UpdatePropertyEntity property,
});
```

#### 2. Use Case (`update_property_usecase.dart`)
```dart
class UpdatePropertyUseCase {
  Future<Either<Failure, PropertyDetailsResponseEntity>> call({
    required UpdatePropertyEntity property,
  });
}
```

### Presentation Layer

#### 1. State Management

**States** (`update_property_state.dart`):
- `UpdatePropertyInitial`: Initial state
- `UpdatePropertyLoading`: While updating property
- `UpdatePropertySuccess`: Update completed successfully
- `UpdatePropertyFailure`: Update failed with error message

**Cubit** (`update_property_cubit.dart`):
- Manages update property state
- Provides `updateProperty()` method
- Includes factory constructor `create()` for easy initialization
- Emits appropriate states based on result

#### 2. UI Screen (`update_property_screen.dart`)

**Features**:
- Pre-filled form with existing property data
- Validates input before submission
- Only sends changed fields to the API
- Shows loading indicator during update
- Displays success/error messages
- Returns to previous screen on success
- Responsive layout with proper RTL support

**Form Fields**:
1. Title (text input)
2. Property Type (dropdown)
3. Offer Type (dropdown)
4. Description (multi-line text)
5. Governorate (dropdown)
6. Price (numeric input)

**Validation**:
- Title: minimum 5 characters
- Description: minimum 10 characters
- Price: must be a valid positive number
- All fields validated before submission

#### 3. Navigation Widget (`edit_property_button.dart`)

**Purpose**: Provides a floating action button to navigate from property details to update screen

**Features**:
- Shows "تعديل العقار" (Edit Property) button
- Passes current property data to update screen
- Refreshes property details after successful update
- Handles navigation and BLoC provider setup

## Usage

### 1. Add Edit Button to Property Details Screen

In `property_details_mobile_layout.dart` or `property_details_tablet_layout.dart`:

```dart
import '../widgets/edit_property_button.dart';

// In your Scaffold:
Scaffold(
  floatingActionButton: EditPropertyButton(property: property),
  body: // ... your existing body
)
```

### 2. Navigate to Update Screen Programmatically

```dart
final result = await Navigator.of(context).push<bool>(
  MaterialPageRoute(
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UpdatePropertyCubit.create()),
        BlocProvider(create: (_) => PropertyTypesCubit.create()),
        BlocProvider(create: (_) => OfferTypesCubit.create()),
        BlocProvider(create: (_) => GovernoratesCubit.create()),
      ],
      child: UpdatePropertyScreen(property: propertyData),
    ),
  ),
);

if (result == true) {
  // Update was successful, refresh data
}
```

### 3. Use UpdatePropertyCubit Directly

```dart
final cubit = UpdatePropertyCubit.create();

cubit.updateProperty(
  propertyId: 107,
  title: "Updated Title",
  price: 60000000.0,
  // Only specify fields you want to update
);

// Listen to state changes
cubit.stream.listen((state) {
  if (state is UpdatePropertySuccess) {
    print('Updated successfully: ${state.response.message}');
  } else if (state is UpdatePropertyFailure) {
    print('Error: ${state.error}');
  }
});
```

## Files Created/Modified

### New Files
1. `lib/features/office_properties/domain/entities/update_property_entity.dart`
2. `lib/features/office_properties/domain/usecases/update_property_usecase.dart`
3. `lib/features/office_properties/data/models/update_property_model.dart`
4. `lib/features/office_properties/presentation/cubit/update_property_state.dart`
5. `lib/features/office_properties/presentation/cubit/update_property_cubit.dart`
6. `lib/features/office_properties/presentation/screens/update_property_screen.dart`
7. `lib/features/office_properties/presentation/widgets/edit_property_button.dart`
8. `lib/features/office_properties/UPDATE_PROPERTY_FEATURE.md`

### Modified Files
1. `lib/core/databases/api/end_points.dart` - Added `updateOfficeProperty()` endpoint
2. `lib/features/office_properties/data/datasources/office_properties_remote_data_source.dart` - Added `updateProperty()` method
3. `lib/features/office_properties/data/repositories/office_properties_repository_impl.dart` - Implemented `updateProperty()` method
4. `lib/features/office_properties/domain/repositories/office_properties_repository.dart` - Added `updateProperty()` interface

## Testing

### Manual Testing Checklist
- [ ] Form loads with existing property data
- [ ] All dropdowns show correct options
- [ ] Form validation works correctly
- [ ] Only changed fields are sent to API
- [ ] Success message displays on successful update
- [ ] Error message displays on failure
- [ ] Property details refresh after update
- [ ] Navigation works correctly
- [ ] RTL layout displays properly
- [ ] Loading indicator shows during update

### Test Cases
1. **Update single field**: Change only title, verify API receives only title
2. **Update multiple fields**: Change title, price, description
3. **No changes**: Try to submit without changes, should show warning
4. **Validation errors**: Test with invalid data (empty title, negative price)
5. **Network error**: Test with no internet connection
6. **Success flow**: Complete update and verify navigation back

## Error Handling

The feature handles the following error scenarios:
1. **Network connectivity issues**: Shows "لا يوجد اتصال بالإنترنت"
2. **Validation errors**: Shows specific field errors
3. **API errors**: Shows server error message
4. **Empty changes**: Shows "لا توجد تغييرات لحفظها"

## Future Enhancements

Potential improvements for future iterations:
1. Add district and neighborhood selection
2. Include location picker for updating coordinates
3. Add price negotiable toggle
4. Support for updating currency
5. Batch update multiple properties
6. Draft/auto-save functionality
7. Image update integration
8. Update history tracking
9. Undo/redo functionality
10. Real-time validation with debouncing

## Notes

- The update is partial (PATCH-like behavior using PUT endpoint)
- Only non-null fields from `UpdatePropertyEntity` are sent to the API
- The response returns the complete updated property data
- Authentication token is automatically included via API consumer interceptor
- Uses the same validation rules as create property where applicable
