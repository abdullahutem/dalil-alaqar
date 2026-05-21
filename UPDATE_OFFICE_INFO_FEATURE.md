# Update Office Info Feature

## Overview
This feature allows office users to update their office information including contact details, social media links, and description.

## API Endpoint
- **Endpoint**: `PUT office/office`
- **Method**: PUT
- **Authentication**: Required (office token)

### Request Body
```json
{
  "phone": "777111222",
  "whatsapp_number": "777111222",
  "email": "newemail@office.com",
  "website": "https://example.com",
  "facebook": "https://facebook.com/office",
  "instagram": "https://instagram.com/office",
  "twitter": "https://twitter.com/office",
  "description": "مكتب عقاري متخصص في بيع وإيجار العقارات",
  "address": "شارع الزبيري، صنعاء"
}
```

### Response
```json
{
  "success": true,
  "message": "تم تحديث معلومات المكتب بنجاح",
  "data": {
    "id": 11,
    "name": "شركة الوفاء العقارية",
    "email": "newemail@office.com",
    "phone": "777111222",
    "whatsapp_number": "777111222",
    "website": "https://example.com",
    "facebook": "https://facebook.com/office",
    "instagram": "https://instagram.com/office",
    "twitter": "https://twitter.com/office",
    "description": "مكتب عقاري متخصص في بيع وإيجار العقارات",
    "address": "شارع الزبيري، صنعاء"
  }
}
```

## Implementation Structure

### 1. Domain Layer

#### Use Case
**File**: `lib/features/office_info/domain/usecases/update_office_info_usecase.dart`
- Handles the business logic for updating office information
- Takes a map of update data and returns either a Failure or OfficeInfoEntity

#### Repository Interface
**File**: `lib/features/office_info/domain/repositories/office_info_repository.dart`
- Added `updateOfficeInfo` method to the abstract repository

### 2. Data Layer

#### Remote Data Source
**File**: `lib/features/office_info/data/datasources/office_info_remote_data_source.dart`
- Added `updateOfficeInfo` method that makes a PUT request to the API
- Uses the ApiConsumer to handle HTTP communication

#### Repository Implementation
**File**: `lib/features/office_info/data/repositories/office_info_repository_impl.dart`
- Implements the `updateOfficeInfo` method
- Handles network connectivity checks
- Manages error handling and data transformation

### 3. Presentation Layer

#### State Management

**States** (`lib/features/office_info/presentation/cubit/office_info_state.dart`):
- `OfficeInfoUpdating`: Emitted when update is in progress
- `OfficeInfoUpdateSuccess`: Emitted when update succeeds (includes updated data and success message)
- `OfficeInfoUpdateError`: Emitted when update fails (includes error message)

**Cubit** (`lib/features/office_info/presentation/cubit/office_info_cubit.dart`):
- Added `updateOfficeInfo` method that:
  - Emits `OfficeInfoUpdating` state
  - Calls the update use case
  - Emits success or error state based on result

#### UI Components

**Update Screen** (`lib/features/office_info/presentation/screens/update_office_info_screen.dart`):
- Full-featured form for editing office information
- Organized into sections:
  - Contact Information (phone, WhatsApp, email, address)
  - Social Media Links (website, Facebook, Instagram, Twitter)
  - Description
- Features:
  - Pre-filled with current office data
  - Form validation for required fields (phone, email)
  - Email format validation
  - Loading state during update
  - Success/error feedback via SnackBar
  - Auto-refresh parent screen on success
  - Responsive design with proper spacing

**Updated Layouts**:
- `office_info_mobile_layout.dart`: Added "Edit Office Info" button with BlocProvider.value to pass the cubit
- `office_info_tablet_layout.dart`: Added "Edit Office Info" button with BlocProvider.value to pass the cubit
- Both layouts refresh data after successful update

**Important**: The cubit is passed to the update screen using `BlocProvider.value()` to ensure the same cubit instance is available in the new route.

## Features

### Form Validation
- **Required Fields**: Phone and Email
- **Email Validation**: Checks for @ symbol
- **Trim Whitespace**: All inputs are trimmed before submission

### User Experience
- Pre-filled form with current data
- Loading indicator during update
- Success message with green SnackBar
- Error message with red SnackBar
- Automatic navigation back on success
- Automatic data refresh after update
- Pull-to-refresh on info screen

### Responsive Design
- Works on both mobile and tablet layouts
- Consistent styling with the rest of the app
- Proper spacing and padding
- Material Design 3 components

## Usage

### Navigation to Update Screen
From the Office Info screen, tap the "تعديل معلومات المكتب" (Edit Office Info) button at the bottom of the page.

### Updating Information
1. Modify any fields you want to update
2. Tap "حفظ التغييرات" (Save Changes)
3. Wait for the update to complete
4. You'll see a success message and be returned to the info screen
5. The info screen will automatically refresh with the new data

### Error Handling
- Network errors are caught and displayed to the user
- Server errors are shown with appropriate messages
- Form validation prevents invalid submissions

## Testing Checklist

- [ ] Form loads with current office data
- [ ] Required field validation works (phone, email)
- [ ] Email format validation works
- [ ] Update request is sent with correct data
- [ ] Loading state is shown during update
- [ ] Success message is displayed on successful update
- [ ] Error message is displayed on failed update
- [ ] Navigation back to info screen works
- [ ] Info screen refreshes after update
- [ ] Works on mobile layout
- [ ] Works on tablet layout
- [ ] Network error handling works
- [ ] Server error handling works

## Files Created/Modified

### Created Files
1. `lib/features/office_info/domain/usecases/update_office_info_usecase.dart`
2. `lib/features/office_info/presentation/screens/update_office_info_screen.dart`

### Modified Files
1. `lib/features/office_info/domain/repositories/office_info_repository.dart`
2. `lib/features/office_info/data/datasources/office_info_remote_data_source.dart`
3. `lib/features/office_info/data/repositories/office_info_repository_impl.dart`
4. `lib/features/office_info/presentation/cubit/office_info_state.dart`
5. `lib/features/office_info/presentation/cubit/office_info_cubit.dart`
6. `lib/features/office_info/presentation/screens/office_info_mobile_layout.dart`
7. `lib/features/office_info/presentation/screens/office_info_tablet_layout.dart`

## Architecture Pattern
This feature follows Clean Architecture principles:
- **Domain Layer**: Business logic and entities
- **Data Layer**: API communication and data transformation
- **Presentation Layer**: UI and state management using Cubit (BLoC pattern)

## Dependencies
No new dependencies were added. The feature uses existing packages:
- `flutter_bloc`: State management
- `dartz`: Functional programming (Either type)
- `dio`: HTTP client (via ApiConsumer)
