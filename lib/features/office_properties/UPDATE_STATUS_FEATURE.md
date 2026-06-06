# Update Property Status Feature

This document describes how to use the property status update feature that allows office users to change the status of their properties.

## Overview

The feature enables users to update property status between:
- **available** (متاح) - Property is available for sale/rent
- **reserved** (محجوز) - Property is reserved
- **sold** (مباع) - Property has been sold

## Architecture

The implementation follows Clean Architecture principles:

### 1. Domain Layer

**Entity**: `OfficePropertyEntity`
- Added `copyWith()` method to support immutable updates

**Repository Interface**: `OfficePropertiesRepository`
```dart
Future<Either<Failure, PropertyDetailsResponseEntity>> updatePropertyStatus({
  required int propertyId,
  required String status,
});
```

**Use Case**: `UpdatePropertyStatusUseCase`
- Located at: `lib/features/office_properties/domain/usecases/update_property_status_usecase.dart`
- Handles the business logic for updating property status

### 2. Data Layer

**Remote Data Source**: `OfficePropertiesRemoteDataSource`
- Endpoint: `PUT office/properties/{id}/status`
- Body: `{"status": "available|reserved|sold"}`

**Repository Implementation**: `OfficePropertiesRepositoryImpl`
- Handles network connectivity checks
- Maps exceptions to failures

**Endpoint**: Added to `EndPoints` class
```dart
static String updateOfficePropertyStatus(int id) => 'office/properties/$id/status';
```

### 3. Presentation Layer

**States**:
- `PropertyDetailsUpdatingStatus` - Shows loading state in details view
- `PropertyDetailsUpdateStatusError` - Shows error in details view
- `OfficePropertiesUpdateStatusError` - Shows error in list view
- Enhanced `OfficePropertiesSuccess` with:
  - `updatingStatusPropertyId` - Tracks which property is being updated
  - `updateStatusSuccessMessage` - Success message after update

**Cubit Methods**:
```dart
// Update property status
Future<bool> updatePropertyStatus({
  required int propertyId,
  required String status,
});

// Clear success message
void clearUpdateStatusMessage();
```

**Widget**: `PropertyStatusDropdown`
- Interactive dropdown to change property status
- Shows loading indicator while updating
- Displays confirmation dialog before updating
- Shows success/error messages via SnackBar

## Usage Examples

### Example 1: Using in Property Card

```dart
import 'package:dalil_alaqar/features/office_properties/presentation/widgets/property_status_dropdown.dart';

// Inside your property card widget
PropertyStatusDropdown(
  propertyId: property.id,
  currentStatus: property.status,
  compact: true, // Use compact style for cards
)
```

### Example 2: Using in Property Details

```dart
// Inside your property details screen
PropertyStatusDropdown(
  propertyId: property.id,
  currentStatus: property.status,
  compact: false, // Use regular size for details
)
```

### Example 3: Programmatic Update

```dart
final cubit = context.read<OfficePropertiesCubit>();

final success = await cubit.updatePropertyStatus(
  propertyId: 84,
  status: 'sold',
);

if (success) {
  // Status updated successfully
  // The property list will be automatically updated
  // Stats will be refreshed
} else {
  // Handle error - error message is in the state
}
```

### Example 4: Listening to State Changes

```dart
BlocListener<OfficePropertiesCubit, OfficePropertiesState>(
  listener: (context, state) {
    if (state is OfficePropertiesSuccess && 
        state.updateStatusSuccessMessage != null) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.updateStatusSuccessMessage!),
          backgroundColor: Colors.green,
        ),
      );
      
      // Clear the message
      context.read<OfficePropertiesCubit>().clearUpdateStatusMessage();
    }
    
    if (state is OfficePropertiesUpdateStatusError) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: YourWidget(),
)
```

## API Details

### Request

**Endpoint**: `PUT /api/office/properties/{id}/status`

**Headers**:
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body**:
```json
{
  "status": "sold"
}
```

**Valid Status Values**:
- `available`
- `reserved`
- `sold`

### Response

**Success Response** (200 OK):
```json
{
  "success": true,
  "message": "تم تحديث حالة العقار بنجاح",
  "data": {
    "id": 84,
    "status": "sold",
    // ... other property fields
  }
}
```

**Error Response** (400/401/404/500):
```json
{
  "success": false,
  "message": "Error message in Arabic"
}
```

## State Management Flow

1. User selects new status from dropdown
2. Confirmation dialog appears
3. User confirms → `updatePropertyStatus()` called
4. State changes to show loading indicator (updatingStatusPropertyId set)
5. API request sent
6. On success:
   - Property list updated with new status
   - Success message displayed
   - Property stats refreshed
7. On failure:
   - Error state emitted
   - Error message displayed
   - Property list remains unchanged

## Benefits

- **Real-time Updates**: Property list reflects changes immediately
- **Optimistic UI**: Shows loading state during update
- **Error Handling**: Graceful error messages in Arabic
- **Stats Sync**: Property stats automatically refresh after update
- **Immutable State**: Uses copyWith pattern for safe state updates
- **Type Safety**: Strongly typed throughout the layers

## Testing Considerations

When testing this feature, verify:

1. **Network Connectivity**: Handles offline scenarios
2. **Concurrent Updates**: Multiple properties being updated
3. **State Consistency**: List and details views stay in sync
4. **Error Recovery**: User can retry after errors
5. **Authorization**: Token validation and expiry
6. **Validation**: Only valid status values accepted

## Future Enhancements

Potential improvements:
- Batch status updates for multiple properties
- Status history tracking
- Status change notifications
- Undo functionality
- Status change reasons/notes
