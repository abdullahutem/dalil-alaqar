# Upload Office Logo Feature

## Overview
This feature allows office users to upload and update their office logo. Users can select an image from their device's gallery or take a new photo with the camera.

## API Endpoint
- **Endpoint**: `POST office/office/logo`
- **Method**: POST
- **Content-Type**: multipart/form-data
- **Authentication**: Required (office token)

### Request Body (Form Data)
```
logo: [image file]
```

### Response
```json
{
  "success": true,
  "message": "تم رفع شعار المكتب بنجاح",
  "data": {
    "logo": "offices/logos/prR9hkqG9UKg64RKBwj1ciI1fm669BWDs59IFX0O.png",
    "logo_url": "https://dalil-alaqar.codebrains.net/storage/offices/logos/prR9hkqG9UKg64RKBwj1ciI1fm669BWDs59IFX0O.png"
  }
}
```

## Implementation Structure

### 1. Domain Layer

#### Use Case
**File**: `lib/features/office_info/domain/usecases/upload_office_logo_usecase.dart`
- Handles the business logic for uploading office logo
- Takes a file path and returns either a Failure or logo data (logo path and URL)

#### Repository Interface
**File**: `lib/features/office_info/domain/repositories/office_info_repository.dart`
- Added `uploadOfficeLogo` method to the abstract repository

### 2. Data Layer

#### Logo Model
**File**: `lib/features/office_info/data/models/office_logo_model.dart`
- Model for the logo upload response
- Contains `logo` (path) and `logoUrl` (full URL)

#### Remote Data Source
**File**: `lib/features/office_info/data/datasources/office_info_remote_data_source.dart`
- Added `uploadOfficeLogo` method that:
  - Creates FormData with the image file
  - Makes a POST request with multipart/form-data
  - Uses `MultipartFile.fromFile` to handle the file upload

#### Repository Implementation
**File**: `lib/features/office_info/data/repositories/office_info_repository_impl.dart`
- Implements the `uploadOfficeLogo` method
- Handles network connectivity checks
- Manages error handling and data transformation

### 3. Presentation Layer

#### State Management

**States** (`lib/features/office_info/presentation/cubit/office_info_state.dart`):
- `OfficeLogoUploading`: Emitted when upload is in progress
- `OfficeLogoUploadSuccess`: Emitted when upload succeeds (includes logo path, URL, and success message)
- `OfficeLogoUploadError`: Emitted when upload fails (includes error message)

**Cubit** (`lib/features/office_info/presentation/cubit/office_info_cubit.dart`):
- Added `uploadOfficeLogo` method that:
  - Emits `OfficeLogoUploading` state
  - Calls the upload use case
  - Emits success or error state based on result
  - Automatically refreshes office info after successful upload

#### UI Components

**Upload Screen** (`lib/features/office_info/presentation/screens/upload_office_logo_screen.dart`):
- Full-featured image upload interface
- Features:
  - Display current logo (if exists)
  - Image picker with camera and gallery options
  - Image preview before upload
  - Image optimization (max 1024x1024, 85% quality)
  - Loading state during upload
  - Success/error feedback via SnackBar
  - Auto-refresh parent screen on success
  - Helpful tips for best results
  - Responsive design

**Updated Header Widget** (`lib/features/office_info/presentation/widgets/office_info_header.dart`):
- Added camera icon button overlay on logo
- Clicking the camera icon opens the upload screen
- Seamlessly integrated with existing design
- Works on both mobile and tablet layouts

**Updated Layouts**:
- `office_info_mobile_layout.dart`: Shows skeleton during logo upload
- `office_info_tablet_layout.dart`: Shows skeleton during logo upload

## Features

### Image Selection
- **Camera**: Take a new photo
- **Gallery**: Select from existing photos
- **Image Optimization**: Automatically resizes to max 1024x1024 and compresses to 85% quality

### User Experience
- Current logo display (if exists)
- Image preview before upload
- Change image option after selection
- Loading indicator during upload
- Success message with green SnackBar
- Error message with red SnackBar
- Automatic navigation back on success
- Automatic data refresh after upload
- Helpful tips card with best practices

### Responsive Design
- Works on both mobile and tablet layouts
- Consistent styling with the rest of the app
- Proper spacing and padding
- Material Design 3 components

## Usage

### Accessing Upload Screen
1. Navigate to Office Info screen
2. Tap the camera icon on the office logo
3. The upload screen will open

### Uploading a Logo
1. Tap the image placeholder or "تغيير الصورة" button
2. Choose between:
   - "التقاط صورة" (Take Photo) - Opens camera
   - "اختيار من المعرض" (Choose from Gallery) - Opens gallery
3. Select or capture an image
4. Preview the selected image
5. Tap "رفع الشعار" (Upload Logo)
6. Wait for the upload to complete
7. You'll see a success message and be returned to the info screen
8. The info screen will automatically refresh with the new logo

### Best Practices
- Use square images for best results
- Transparent background is recommended
- Maximum size: 1024x1024 pixels
- Supported formats: PNG, JPG

## Error Handling
- Network errors are caught and displayed to the user
- Server errors are shown with appropriate messages
- Image selection errors are handled gracefully
- File access errors are caught and reported

## Testing Checklist

- [ ] Camera permission works on iOS and Android
- [ ] Gallery permission works on iOS and Android
- [ ] Image selection from camera works
- [ ] Image selection from gallery works
- [ ] Image preview displays correctly
- [ ] Image optimization works (size and quality)
- [ ] Upload request is sent with correct form data
- [ ] Loading state is shown during upload
- [ ] Success message is displayed on successful upload
- [ ] Error message is displayed on failed upload
- [ ] Navigation back to info screen works
- [ ] Info screen refreshes after upload
- [ ] New logo displays correctly
- [ ] Works on mobile layout
- [ ] Works on tablet layout
- [ ] Network error handling works
- [ ] Server error handling works
- [ ] Camera icon button is visible and clickable

## Files Created/Modified

### Created Files
1. `lib/features/office_info/data/models/office_logo_model.dart`
2. `lib/features/office_info/domain/usecases/upload_office_logo_usecase.dart`
3. `lib/features/office_info/presentation/screens/upload_office_logo_screen.dart`

### Modified Files
1. `lib/core/databases/api/end_points.dart` - Added `officeLogo` endpoint
2. `lib/features/office_info/data/datasources/office_info_remote_data_source.dart` - Added upload method
3. `lib/features/office_info/domain/repositories/office_info_repository.dart` - Added upload method signature
4. `lib/features/office_info/data/repositories/office_info_repository_impl.dart` - Implemented upload method
5. `lib/features/office_info/presentation/cubit/office_info_state.dart` - Added upload states
6. `lib/features/office_info/presentation/cubit/office_info_cubit.dart` - Added upload method
7. `lib/features/office_info/presentation/widgets/office_info_header.dart` - Added camera button
8. `lib/features/office_info/presentation/screens/office_info_mobile_layout.dart` - Added upload loading state
9. `lib/features/office_info/presentation/screens/office_info_tablet_layout.dart` - Added upload loading state
10. `pubspec.yaml` - Added `image_picker` dependency

## Architecture Pattern
This feature follows Clean Architecture principles:
- **Domain Layer**: Business logic and entities
- **Data Layer**: API communication and data transformation
- **Presentation Layer**: UI and state management using Cubit (BLoC pattern)

## Dependencies

### New Dependencies
- `image_picker: ^1.1.2` - For selecting images from camera/gallery

### Existing Dependencies Used
- `flutter_bloc`: State management
- `dartz`: Functional programming (Either type)
- `dio`: HTTP client with multipart support

## Platform Configuration

### iOS (Info.plist)
Add these permissions to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>نحتاج إلى الوصول إلى الكاميرا لالتقاط صورة الشعار</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>نحتاج إلى الوصول إلى المعرض لاختيار صورة الشعار</string>
```

### Android (AndroidManifest.xml)
Permissions are automatically added by the image_picker package.

## Notes
- Images are automatically optimized before upload to reduce bandwidth
- The upload uses multipart/form-data for efficient file transfer
- After successful upload, the office info is automatically refreshed
- The feature integrates seamlessly with existing office info screens
- Skeleton loading provides visual feedback during upload
