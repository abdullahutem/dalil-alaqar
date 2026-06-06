# Update Profile Feature Documentation

## Overview
This feature allows users to update their profile information including name, phone number, and WhatsApp number through a dedicated edit screen.

## API Endpoint
- **Endpoint**: `office/profile`
- **Method**: PUT
- **Request Body**:
```json
{
  "name": "حيدر علي الحسيني",
  "phone_number": "777999888",
  "whatsapp_number": "777999888"
}
```
- **Response**:
```json
{
  "success": true,
  "message": "تم تحديث الملف الشخصي بنجاح",
  "data": {
    "id": 32,
    "name": "حيدر علي الحسيني",
    "email": "owner-shrk-alofaaa-alaakary@dalilaqar.iq",
    "phone_number": "777999888",
    "whatsapp_number": "777999888"
  }
}
```

## Architecture

### Domain Layer

#### Entities
- **UpdateProfileParams**: Input parameters for updating profile
  - `name`: User's full name (required)
  - `phoneNumber`: User's phone number (required)
  - `whatsappNumber`: User's WhatsApp number (optional)

- **UpdatedUserEntity**: Response entity containing updated user data
  - `id`: User ID
  - `name`: Updated name
  - `email`: Email (cannot be changed)
  - `phoneNumber`: Updated phone number
  - `whatsappNumber`: Updated WhatsApp number

#### Repository Interface
- `ProfileRepository.updateProfile(UpdateProfileParams)`: Abstract method for updating profile

#### Use Case
- **UpdateProfileUseCase**: Handles the business logic for updating profile
  - Validates input through repository
  - Returns Either<Failure, UpdatedUserEntity>

### Data Layer

#### Models
- **UpdatedUserModel**: Extends `UpdatedUserEntity` with JSON serialization
  - `fromJson()`: Deserializes API response
  - `toJson()`: Serializes for API requests

#### Data Source
- **ProfileRemoteDataSource.updateProfile()**: API communication
  - Makes PUT request to `office/profile`
  - Handles response parsing
  - Throws exceptions on failure

#### Repository Implementation
- **ProfileRepositoryImpl.updateProfile()**: Implementation
  - Checks network connectivity
  - Calls remote data source
  - Handles errors and returns Either type

### Presentation Layer

#### Cubit States
Extended `ProfileState` with new states:
- **ProfileUpdating**: Profile update in progress
- **ProfileUpdated**: Profile updated successfully
  - Contains `UpdatedUserEntity`
- **ProfileUpdateError**: Update failed
  - Contains error message

#### ProfileCubit Methods
- **updateProfile(UpdateProfileParams)**: Triggers profile update
  - Emits `ProfileUpdating` state
  - Calls use case
  - Emits `ProfileUpdated` or `ProfileUpdateError`
  - Automatically reloads profile on success

## UI Components

### Profile Screen (`profile_screen.dart`)
Full-screen view displaying complete user and office information:

**Features:**
- Displays user avatar/office logo
- Shows user name and role badge
- Two information cards:
  1. **User Info Card**:
     - Email (read-only)
     - Phone number
     - WhatsApp number (if available)
  2. **Office Info Card**:
     - Office name
     - Office email
     - Office phone
     - Subscription type

- Edit button in AppBar to navigate to edit screen
- Loading state with skeleton
- Error state with retry button
- Pull-to-refresh functionality

**Navigation:**
- Accessible from Dashboard drawer → "الملف الشخصي"
- Route: `AppRoutes.profileScreen`

### Edit Profile Screen (`edit_profile_screen.dart`)
Modal screen for editing user profile:

**Features:**
- **Form Fields**:
  1. Name field (required, min 3 characters)
  2. Phone number field (required, min 8 digits)
  3. WhatsApp number field (optional, min 8 digits if provided)

- **Validation**:
  - Client-side validation for all fields
  - Real-time error display
  - Empty field validation
  - Length validation

- **UI Elements**:
  - Large profile icon at top
  - Labeled input fields with icons
  - Submit button with loading state
  - Info banner explaining email cannot be changed

- **User Feedback**:
  - Success SnackBar on successful update
  - Error SnackBar on failure
  - Loading indicator in button during update
  - Auto-close on success

**Behavior:**
- Opens from Profile Screen edit button
- Pre-fills with current user data
- Disables button during update
- Returns `true` on success to trigger profile reload
- BlocProvider.value passes ProfileCubit from parent

## User Flow

1. **View Profile**:
   ```
   Dashboard → Open Drawer → Click "الملف الشخصي" → Profile Screen
   ```

2. **Edit Profile**:
   ```
   Profile Screen → Click Edit Icon → Edit Profile Screen
   → Fill Form → Click "حفظ التعديلات"
   → Success Message → Auto-close → Profile Reloaded
   ```

3. **Dashboard Drawer**:
   ```
   Dashboard → Open Drawer → See Profile Header
   → Profile loads automatically with skeleton
   → Displays updated info after edit
   ```

## Integration Points

### Dashboard Drawer
- Profile header shows user info
- Menu item links to Profile Screen
- Automatically refreshes on drawer open

### Routes
- Added `AppRoutes.profileScreen = '/profile_screen'`
- Registered in `AppRouter.onGenerateRoute()`

## Validation Rules

### Name Field
- **Required**: Yes
- **Min Length**: 3 characters
- **Max Length**: No limit
- **Error Messages**:
  - Empty: "الرجاء إدخال الاسم"
  - Too short: "الاسم يجب أن يكون 3 أحرف على الأقل"

### Phone Number Field
- **Required**: Yes
- **Type**: Phone
- **Min Length**: 8 digits
- **Error Messages**:
  - Empty: "الرجاء إدخال رقم الهاتف"
  - Too short: "رقم الهاتف غير صحيح"

### WhatsApp Number Field
- **Required**: No
- **Type**: Phone
- **Min Length**: 8 digits (if provided)
- **Error Messages**:
  - Too short: "رقم الواتساب غير صحيح"

## State Management Flow

```
User clicks "حفظ التعديلات"
    ↓
Form validation
    ↓
ProfileCubit.updateProfile(params)
    ↓
Emit ProfileUpdating
    ↓
Call UpdateProfileUseCase
    ↓
Repository checks network
    ↓
Remote data source PUT request
    ↓
Success:
  → Emit ProfileUpdated(user)
  → Show success SnackBar
  → Close edit screen
  → Reload profile in Profile Screen
    
Failure:
  → Emit ProfileUpdateError(message)
  → Show error SnackBar
  → Stay on edit screen
```

## File Structure
```
lib/features/profile/
├── domain/
│   ├── entities/
│   │   ├── update_profile_params.dart       [NEW]
│   │   └── updated_user_entity.dart         [NEW]
│   ├── repositories/
│   │   └── profile_repository.dart          [UPDATED]
│   └── usecases/
│       └── update_profile_usecase.dart      [NEW]
├── data/
│   ├── models/
│   │   └── updated_user_model.dart          [NEW]
│   ├── datasources/
│   │   └── profile_remote_data_source.dart  [UPDATED]
│   └── repositories/
│       └── profile_repository_impl.dart     [UPDATED]
└── presentation/
    ├── cubit/
    │   ├── profile_cubit.dart               [UPDATED]
    │   └── profile_state.dart               [UPDATED]
    └── screens/
        ├── profile_screen.dart              [NEW]
        └── edit_profile_screen.dart         [NEW]
```

## Testing

### Manual Testing Steps

1. **Navigate to Profile**:
   - Open dashboard
   - Open drawer
   - Click "الملف الشخصي"
   - Verify profile data displays correctly

2. **Edit Profile**:
   - Click edit icon
   - Modify name, phone, and WhatsApp
   - Click save
   - Verify success message
   - Verify screen closes
   - Verify profile shows updated data

3. **Validation Testing**:
   - Try to submit empty name → Error shown
   - Try short name (2 chars) → Error shown
   - Try short phone (<8 digits) → Error shown
   - Valid data → Success

4. **Network Testing**:
   - Turn off network
   - Try to update
   - Verify network error message

5. **Loading State**:
   - Click save
   - Verify button shows loading
   - Verify button is disabled during update

## Error Handling

- **Network Errors**: "لا يوجد اتصال بالإنترنت"
- **Server Errors**: Display server message
- **Validation Errors**: Field-specific messages
- **Unknown Errors**: "Failed to update profile"

All errors shown in red SnackBar with 3-second duration.

## Success Feedback

- Green SnackBar with message: "تم تحديث الملف الشخصي بنجاح"
- Auto-close edit screen after 2 seconds
- Profile data refreshes automatically

## Notes

- Email field is **read-only** and cannot be changed
- WhatsApp number is **optional**
- Profile automatically reloads after successful update
- Drawer header updates automatically when reopened
- Uses same ProfileCubit instance between Profile and Edit screens
- Form validation happens on submit
- Loading state prevents duplicate submissions

## Future Enhancements

- [ ] Add avatar/profile picture upload
- [ ] Add password change functionality
- [ ] Add address field
- [ ] Add email change with verification
- [ ] Add more detailed validation (phone format)
- [ ] Add field-level validation on blur
- [ ] Cache profile data locally
- [ ] Add biometric authentication for sensitive changes
