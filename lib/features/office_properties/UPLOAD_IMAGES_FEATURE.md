# Upload Multiple Images Feature

## Overview
This feature allows office users to upload multiple images to their properties through a user-friendly interface.

## API Endpoint
- **URL**: `office/properties/{id}/images/multiple`
- **Method**: `POST`
- **Content-Type**: `multipart/form-data`
- **Body**: 
  - `images[]` (file) - Multiple image files

## Response Format
```json
{
  "success": true,
  "message": "تم رفع الصور بنجاح",
  "data": [
    {
      "id": 448,
      "image_path": "properties/images/481wInA9lKUdAZBLCOmeg7GMsjrQbKfZNdwRt0R9.jpg",
      "is_primary": false,
      "order": 9
    },
    {
      "id": 449,
      "image_path": "properties/images/8KykEoh2TkeAAFoWVA2O6Q9dPObCpH0bDLx33Q9r.png",
      "is_primary": false,
      "order": 10
    }
  ]
}
```

## Architecture

### Data Layer
1. **Entity**: `UploadImagesResponseEntity`
   - Location: `domain/entities/upload_images_response_entity.dart`
   - Contains: success, message, list of uploaded images

2. **Model**: `UploadImagesResponseModel`
   - Location: `data/models/upload_images_response_model.dart`
   - Extends: `UploadImagesResponseEntity`
   - Has: `fromJson()` and `toJson()` methods

3. **Data Source**: `OfficePropertiesRemoteDataSource`
   - Location: `data/datasources/office_properties_remote_data_source.dart`
   - Method: `uploadPropertyImages(propertyId, imagePaths)`
   - Creates FormData with multiple images using `images[]` key

4. **Repository Implementation**: `OfficePropertiesRepositoryImpl`
   - Location: `data/repositories/office_properties_repository_impl.dart`
   - Implements: `uploadPropertyImages()` with network check and error handling

### Domain Layer
1. **Repository Interface**: `OfficePropertiesRepository`
   - Location: `domain/repositories/office_properties_repository.dart`
   - Method signature: `Future<Either<Failure, UploadImagesResponseEntity>>`

2. **UseCase**: `UploadPropertyImagesUseCase`
   - Location: `domain/usecases/upload_property_images_usecase.dart`
   - Calls repository to upload images

### Presentation Layer
1. **State Management**:
   - **States** (`cubit/upload_images_state.dart`):
     - `UploadImagesInitial`
     - `UploadImagesLoading`
     - `UploadImagesSuccess`
     - `UploadImagesError`
   
   - **Cubit** (`cubit/upload_images_cubit.dart`):
     - `uploadImages()`: Uploads images to the server
     - `resetState()`: Resets to initial state
     - Factory: `UploadImagesCubit.create()` for easy instantiation

2. **UI Widget**: `UploadPropertyImagesWidget`
   - Location: `presentation/widgets/upload_property_images_widget.dart`
   - Features:
     - Pick multiple images from gallery
     - Preview selected images with thumbnails
     - Remove individual images before upload
     - Upload all selected images at once
     - Loading state with progress indicator
     - Success/Error feedback with SnackBar
     - Auto-refresh property details after successful upload
     - RTL support for Arabic interface

3. **Integration**:
   - **Mobile Layout** (`screens/property_details_mobile_layout.dart`):
     - Upload button in SliverAppBar actions
     - Icon button with camera icon overlay on image gallery
   
   - **Tablet Layout** (`screens/property_details_tablet_layout.dart`):
     - Upload button overlaid on top-right of image gallery
     - More prominent button with text label

## User Flow
1. User opens property details screen
2. User clicks the "Upload Images" button (camera icon on mobile, labeled button on tablet)
3. Bottom sheet opens with upload interface
4. User clicks "اختيار صور" to open image picker
5. User selects multiple images from gallery
6. Selected images appear as thumbnails with remove buttons
7. User can remove unwanted images
8. User clicks "رفع الصور" to upload
9. Loading indicator shows during upload
10. Success message appears and images refresh automatically
11. Bottom sheet closes and property details refresh

## Features
- ✅ Multiple image selection
- ✅ Image preview before upload
- ✅ Remove images from selection
- ✅ Real-time upload progress
- ✅ Success/Error feedback
- ✅ Auto-refresh after upload
- ✅ Network connectivity check
- ✅ Clean Architecture (Data/Domain/Presentation layers)
- ✅ State management with Bloc/Cubit
- ✅ RTL support for Arabic
- ✅ Responsive design (Mobile & Tablet)

## Dependencies
- `image_picker: ^1.1.2` - For selecting images from gallery
- `dio` - For multipart file upload
- `flutter_bloc` - For state management

## Error Handling
- Network connectivity check before upload
- Image picker failure handling
- Server error handling with user-friendly messages
- Loading states to prevent duplicate submissions

## Future Enhancements
- Image compression before upload
- Progress percentage indicator
- Drag and drop reordering
- Set image as primary
- Delete uploaded images
- Image editing (crop, rotate)
