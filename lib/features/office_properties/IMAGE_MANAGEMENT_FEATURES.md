# Image Management Features Summary

## Overview
Two complementary features for managing property images in the office properties module:
1. **Upload Multiple Images** - Upload multiple images at once
2. **Set Primary Image** - Mark any image as the primary/main image

---

## 1. Upload Multiple Images

### Endpoint
```
POST office/properties/{id}/images/multiple
Content-Type: multipart/form-data
Body: images[] (multiple files)
```

### Key Features
- Select multiple images from gallery
- Preview selected images before upload
- Remove images from selection
- Progress indicator during upload
- Success/Error feedback
- Auto-refresh property details

### UI Components
- Bottom sheet with image picker
- Thumbnail preview grid
- Upload button with loading state
- Remove buttons on thumbnails

### Access Points
- **Mobile**: Camera icon button in SliverAppBar actions
- **Tablet**: "رفع صور" button overlaid on image gallery

---

## 2. Set Primary Image

### Endpoint
```
POST office/properties/{propertyId}/images/{imageId}/primary
```

### Key Features
- Set any uploaded image as primary
- Visual indicator for current primary image
- Confirmation before setting
- Auto-refresh after update
- Works in fullscreen image viewer

### UI Components
- Star icon button for non-primary images
- Yellow badge with star for primary images
- Confirmation dialog
- Success/Error SnackBar

### Access Points
- Available in fullscreen image gallery view
- Shows when viewing property details images

---

## Complete User Workflow

### Scenario 1: New Property with Images
1. Create property without images
2. Open property details
3. Tap upload button (camera icon or "رفع صور")
4. Select multiple images from gallery
5. Review and remove unwanted images
6. Upload all images
7. Images appear in gallery
8. Tap any image to view fullscreen
9. Tap star icon to set as primary
10. Primary image now shows in property listings

### Scenario 2: Add More Images to Existing Property
1. Open property details
2. Tap upload button
3. Select additional images
4. Upload successfully
5. Optionally change primary image

---

## Architecture Overview

### Clean Architecture Layers

#### Domain Layer (Business Logic)
- **Entities**:
  - `UploadImagesResponseEntity`
  - `PropertyImageEntity`
  
- **UseCases**:
  - `UploadPropertyImagesUseCase`
  - `SetPrimaryImageUseCase`
  
- **Repository Interfaces**:
  - `uploadPropertyImages()`
  - `setPrimaryImage()`

#### Data Layer (API Integration)
- **Models**:
  - `UploadImagesResponseModel`
  - `PropertyImageModel`
  
- **Remote Data Source**:
  - `uploadPropertyImages()` - FormData with multiple files
  - `setPrimaryImage()` - Simple POST request
  
- **Repository Implementation**:
  - Network connectivity checks
  - Error handling
  - Data transformation

#### Presentation Layer (UI & State)
- **Cubits**:
  - `UploadImagesCubit` - Manages upload state
  - `PropertyDetailsCubit` - Enhanced with setPrimaryImage
  
- **States**:
  - `UploadImagesState` (Initial/Loading/Success/Error)
  - `PropertyDetailsState` (unchanged, reused)
  
- **Widgets**:
  - `UploadPropertyImagesWidget` - Upload UI
  - `PropertyImageGallery` - Enhanced with set primary

---

## API Endpoints

### EndPoints Class Updates
```dart
static String uploadPropertyImages(int id) =>
    'office/properties/$id/images/multiple';
    
static String setPrimaryImage(int propertyId, int imageId) =>
    'office/properties/$propertyId/images/$imageId/primary';
```

---

## Files Created/Modified

### Created Files (8 files)
1. `domain/entities/upload_images_response_entity.dart`
2. `domain/usecases/upload_property_images_usecase.dart`
3. `domain/usecases/set_primary_image_usecase.dart`
4. `data/models/upload_images_response_model.dart`
5. `presentation/cubit/upload_images_cubit.dart`
6. `presentation/cubit/upload_images_state.dart`
7. `presentation/widgets/upload_property_images_widget.dart`
8. `core/databases/api/end_points.dart` (updated)

### Modified Files (9 files)
1. `data/datasources/office_properties_remote_data_source.dart`
2. `data/repositories/office_properties_repository_impl.dart`
3. `domain/repositories/office_properties_repository.dart`
4. `presentation/cubit/property_details_cubit.dart`
5. `presentation/widgets/property_image_gallery.dart`
6. `presentation/widgets/office_property_card.dart` (null safety fix)
7. `presentation/screens/property_details_mobile_layout.dart`
8. `presentation/screens/property_details_tablet_layout.dart`
9. `core/databases/api/end_points.dart`

---

## Key Technical Decisions

### 1. Callback Pattern for Context Access
**Problem**: Bottom sheet creates new context without parent BlocProviders  
**Solution**: Pass `onUploadSuccess` callback to refresh from parent context

### 2. Cubit Lifecycle Management
**Problem**: BlocProvider created in build() causing provider lookup errors  
**Solution**: Create cubit in initState(), dispose in dispose(), use BlocProvider.value

### 3. Null Safety for Images
**Problem**: Properties without images caused null pointer exceptions  
**Solution**: Check `imageUrl != null` before using, show placeholder otherwise

### 4. BlocProvider in Navigation
**Problem**: Fullscreen gallery needs access to PropertyDetailsCubit  
**Solution**: Use BlocProvider.value to pass existing cubit through navigation

---

## Error Handling

### Network Errors
- Check connectivity before API calls
- Show user-friendly error messages
- Maintain state consistency

### Validation Errors
- Prevent upload with no images selected
- Confirm before setting primary image
- Handle missing propertyId gracefully

### UI Error States
- Loading indicators during operations
- Disable buttons during processing
- Clear error messages in SnackBars

---

## Testing Considerations

### Unit Tests
- Repository methods with mocked data sources
- UseCases with mocked repositories
- Cubit state transitions

### Widget Tests
- Upload widget with image selection
- Gallery widget with primary badge
- Button states and interactions

### Integration Tests
- Complete upload flow
- Set primary image flow
- Error handling scenarios

---

## Performance Optimizations

### Image Handling
- Image quality reduced to 80% during selection
- Uses image_picker plugin efficiently
- CachedNetworkImage for display

### State Management
- Minimal rebuilds with BlocConsumer
- Efficient state updates
- Proper disposal of resources

### Network Optimization
- FormData for efficient multipart upload
- Single API call for multiple images
- Optimistic UI updates where possible

---

## Accessibility

### Visual Feedback
- Loading indicators
- Success/Error messages
- Clear button labels in Arabic

### RTL Support
- Full right-to-left layout
- Arabic text throughout
- Proper alignment

---

## Dependencies Used

```yaml
image_picker: ^1.1.2  # Already in project
dio: ^x.x.x            # Already in project
flutter_bloc: ^x.x.x   # Already in project
cached_network_image: ^x.x.x  # Already in project
```

---

## Future Enhancements

### Short Term
- Image compression before upload
- Progress percentage indicator
- Drag and drop reordering
- Delete uploaded images

### Long Term
- Image editing (crop, rotate, filters)
- Bulk operations
- Image metadata editing
- Auto-detect best primary image (ML)
- Image optimization suggestions

---

## Known Limitations

1. No image size validation on client side
2. No duplicate image detection
3. Cannot delete images after upload (feature not yet implemented)
4. No image reordering capability
5. Limited to device gallery (no camera direct capture)

---

## Troubleshooting

### Issue: Provider not found errors
**Solution**: Ensure BlocProvider.value is used when navigating with bottom sheets

### Issue: Images not refreshing after upload
**Solution**: Check that onUploadSuccess callback is properly passed and called

### Issue: Null pointer on primaryImageUrl
**Solution**: Always check for null before using, show placeholder for null images

### Issue: Upload button not showing
**Solution**: Verify widget imports and propertyId is passed correctly

---

## Documentation Files

1. `UPLOAD_IMAGES_FEATURE.md` - Detailed upload feature documentation
2. `SET_PRIMARY_IMAGE_FEATURE.md` - Detailed set primary documentation
3. `IMAGE_MANAGEMENT_FEATURES.md` - This comprehensive overview

---

## Conclusion

These features provide a complete image management solution for office properties, following clean architecture principles and Flutter best practices. The implementation is scalable, maintainable, and user-friendly with proper error handling and feedback mechanisms.
