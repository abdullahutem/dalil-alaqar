# Set Primary Image Feature

## Overview
This feature allows office users to set any uploaded image as the primary image for their property. The primary image is displayed as the main thumbnail in property listings.

## API Endpoint
- **URL**: `office/properties/{propertyId}/images/{imageId}/primary`
- **Method**: `POST`
- **Parameters**: 
  - `propertyId` (path) - The property ID
  - `imageId` (path) - The image ID to set as primary

## Response Format
```json
{
  "success": true,
  "message": "تم تعيين الصورة كرئيسية بنجاح",
  "data": null
}
```

## Architecture

### Data Layer
1. **Data Source**: `OfficePropertiesRemoteDataSource`
   - Location: `data/datasources/office_properties_remote_data_source.dart`
   - Method: `setPrimaryImage(propertyId, imageId)`
   - Returns: Success message string

2. **Repository Implementation**: `OfficePropertiesRepositoryImpl`
   - Location: `data/repositories/office_properties_repository_impl.dart`
   - Implements: `setPrimaryImage()` with network check and error handling

### Domain Layer
1. **Repository Interface**: `OfficePropertiesRepository`
   - Location: `domain/repositories/office_properties_repository.dart`
   - Method signature: `Future<Either<Failure, String>>`

2. **UseCase**: `SetPrimaryImageUseCase`
   - Location: `domain/usecases/set_primary_image_usecase.dart`
   - Calls repository to set primary image

### Presentation Layer
1. **Cubit Update**: `PropertyDetailsCubit`
   - Location: `presentation/cubit/property_details_cubit.dart`
   - New Method: `setPrimaryImage(propertyId, imageId)`
   - Returns: `bool` indicating success/failure
   - Auto-refreshes property details after setting primary image

2. **UI Widget**: `PropertyImageGallery`
   - Location: `presentation/widgets/property_image_gallery.dart`
   - Updated to accept optional `propertyId` parameter
   - Fullscreen gallery now shows:
     - **Star icon button** for non-primary images (allows setting as primary)
     - **Primary badge** with star icon for images already marked as primary
   - Confirmation dialog before setting primary
   - Success/Error feedback with SnackBar
   - Auto-refresh and close fullscreen after successful update

3. **Integration**:
   - **Mobile Layout** (`screens/property_details_mobile_layout.dart`):
     - Passes `propertyId` to PropertyImageGallery
   
   - **Tablet Layout** (`screens/property_details_tablet_layout.dart`):
     - Passes `propertyId` to PropertyImageGallery

## User Flow
1. User opens property details screen
2. User taps on any image to view it fullscreen
3. User navigates through images using swipe gestures
4. For non-primary images:
   - User sees a star icon button in the app bar
   - User taps the star button
   - Confirmation dialog appears
   - User confirms the action
   - API call is made to set the image as primary
   - Success message is shown
   - Property details refresh automatically
   - Fullscreen view closes
5. For primary images:
   - User sees a yellow badge with "رئيسية" (Primary) text
   - No action button is shown

## Features
- ✅ Set any image as primary
- ✅ Visual indicator for primary images (star badge)
- ✅ Confirmation dialog before setting
- ✅ Success/Error feedback
- ✅ Auto-refresh property details
- ✅ Network connectivity check
- ✅ Clean Architecture implementation
- ✅ State management with Bloc/Cubit
- ✅ Works in both mobile and tablet layouts
- ✅ BlocProvider passed correctly to fullscreen view

## UI Elements
- **Star Icon Button**: Shows on non-primary images in fullscreen view
- **Primary Badge**: Yellow badge with star and "رئيسية" text for primary images
- **Confirmation Dialog**: Asks user to confirm before setting primary
- **Success SnackBar**: Green message confirming the action
- **Error SnackBar**: Red message if the operation fails

## Error Handling
- Network connectivity check before API call
- Server error handling with user-friendly messages
- Loading states during API call
- Graceful handling when propertyId is not available

## Dependencies
- `flutter_bloc` - For state management
- `dio` - For API calls
- `cached_network_image` - For image display

## Integration with Other Features
- Works seamlessly with the **Upload Multiple Images** feature
- After uploading images, users can immediately set one as primary
- Property listings automatically update to show the new primary image
- Works with the existing image gallery and fullscreen viewer

## Future Enhancements
- Swipe gesture to set primary (swipe up on image)
- Batch operations (set primary while uploading)
- Reorder images with drag and drop
- Set primary directly from thumbnail grid
