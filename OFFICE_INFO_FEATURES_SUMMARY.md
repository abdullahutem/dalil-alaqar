# Office Info Features Summary

This document provides an overview of all implemented office information management features.

## Features Implemented

### 1. Get Office Info ✅
**Status**: Already Implemented

Displays the office information including:
- Office name and logo
- Contact information (phone, WhatsApp, email, address)
- Social media links (website, Facebook, Instagram, Twitter)
- Office description
- Office status (active/inactive)

**Screens**:
- `office_info_screen.dart` - Main screen
- `office_info_mobile_layout.dart` - Mobile responsive layout
- `office_info_tablet_layout.dart` - Tablet responsive layout

---

### 2. Update Office Info ✅
**Status**: Newly Implemented

Allows office users to update their office information through a comprehensive form.

**Endpoint**: `PUT office/office`

**Features**:
- Pre-filled form with current data
- Form validation (required fields, email format)
- Organized sections (Contact Info, Social Media, Description)
- Loading indicator during update
- Success/error feedback
- Auto-refresh after update
- Skeleton loading on main screen during update

**Key Files**:
- `update_office_info_screen.dart` - Update form UI
- `update_office_info_usecase.dart` - Business logic
- Updated cubit with update states and methods

**Documentation**: See `UPDATE_OFFICE_INFO_FEATURE.md`

---

### 3. Upload Office Logo ✅
**Status**: Newly Implemented

Allows office users to upload and update their office logo with image selection from camera or gallery.

**Endpoint**: `POST office/office/logo`

**Features**:
- Camera icon button on logo for easy access
- Image selection from camera or gallery
- Image preview before upload
- Automatic image optimization (1024x1024, 85% quality)
- Current logo display
- Loading indicator during upload
- Success/error feedback
- Auto-refresh after upload
- Skeleton loading on main screen during upload
- Helpful tips for best results

**Key Files**:
- `upload_office_logo_screen.dart` - Upload UI
- `upload_office_logo_usecase.dart` - Business logic
- `office_logo_model.dart` - Response model
- Updated header widget with camera button
- Updated cubit with upload states and methods

**Documentation**: See `UPLOAD_OFFICE_LOGO_FEATURE.md`

---

## Architecture

All features follow **Clean Architecture** principles:

```
lib/features/office_info/
├── data/
│   ├── datasources/
│   │   └── office_info_remote_data_source.dart
│   ├── models/
│   │   ├── office_info_model.dart
│   │   └── office_logo_model.dart
│   └── repositories/
│       └── office_info_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── office_info_entity.dart
│   ├── repositories/
│   │   └── office_info_repository.dart
│   └── usecases/
│       ├── get_office_info_usecase.dart
│       ├── update_office_info_usecase.dart
│       └── upload_office_logo_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── office_info_cubit.dart
    │   └── office_info_state.dart
    ├── screens/
    │   ├── office_info_screen.dart
    │   ├── office_info_mobile_layout.dart
    │   ├── office_info_tablet_layout.dart
    │   ├── update_office_info_screen.dart
    │   └── upload_office_logo_screen.dart
    └── widgets/
        ├── office_info_header.dart
        ├── office_info_contact_card.dart
        ├── office_info_social_card.dart
        ├── office_info_description_card.dart
        └── office_info_skeleton.dart
```

## State Management

Using **BLoC/Cubit** pattern with the following states:

### Get Office Info States
- `OfficeInfoInitial` - Initial state
- `OfficeInfoLoading` - Loading office info
- `OfficeInfoSuccess` - Successfully loaded office info
- `OfficeInfoError` - Error loading office info

### Update Office Info States
- `OfficeInfoUpdating` - Updating office info
- `OfficeInfoUpdateSuccess` - Successfully updated office info
- `OfficeInfoUpdateError` - Error updating office info

### Upload Logo States
- `OfficeLogoUploading` - Uploading logo
- `OfficeLogoUploadSuccess` - Successfully uploaded logo
- `OfficeLogoUploadError` - Error uploading logo

## API Endpoints

| Feature | Method | Endpoint | Content-Type |
|---------|--------|----------|--------------|
| Get Office Info | GET | `office/office` | application/json |
| Update Office Info | PUT | `office/office` | application/json |
| Upload Office Logo | POST | `office/office/logo` | multipart/form-data |

## Dependencies

### Core Dependencies
- `flutter_bloc: ^9.1.1` - State management
- `dartz: ^0.10.1` - Functional programming
- `dio: ^5.9.2` - HTTP client
- `equatable: ^2.0.8` - Value equality

### Feature-Specific Dependencies
- `image_picker: ^1.1.2` - Image selection (for logo upload)
- `cached_network_image: ^3.4.1` - Image caching and display

## User Flow

### Update Office Info Flow
1. User views office info screen
2. User taps "تعديل معلومات المكتب" button
3. Update form opens with pre-filled data
4. User modifies desired fields
5. User taps "حفظ التغييرات"
6. Loading indicator shows on button
7. Main screen shows skeleton loading
8. Success message appears
9. User returns to office info screen
10. Updated data is displayed

### Upload Logo Flow
1. User views office info screen
2. User taps camera icon on logo
3. Upload screen opens showing current logo
4. User taps image placeholder
5. Bottom sheet appears with camera/gallery options
6. User selects image source
7. Image is selected and previewed
8. User taps "رفع الشعار"
9. Loading indicator shows
10. Main screen shows skeleton loading
11. Success message appears
12. User returns to office info screen
13. New logo is displayed

## Error Handling

All features include comprehensive error handling:
- Network connectivity checks
- Server error handling
- Form validation errors
- Image selection errors
- User-friendly error messages in Arabic
- Retry mechanisms where appropriate

## Responsive Design

All screens are responsive and work on:
- Mobile devices (portrait and landscape)
- Tablets (portrait and landscape)
- Different screen sizes and densities

## Localization

All UI text is in Arabic:
- Form labels and placeholders
- Button text
- Error messages
- Success messages
- Helper text

## Testing Recommendations

### Unit Tests
- [ ] Test all use cases
- [ ] Test repository implementations
- [ ] Test data source methods
- [ ] Test model serialization/deserialization

### Widget Tests
- [ ] Test form validation
- [ ] Test button states
- [ ] Test error displays
- [ ] Test success displays

### Integration Tests
- [ ] Test complete update flow
- [ ] Test complete upload flow
- [ ] Test navigation between screens
- [ ] Test state transitions

### Manual Tests
- [ ] Test on real devices (iOS and Android)
- [ ] Test camera permissions
- [ ] Test gallery permissions
- [ ] Test with slow network
- [ ] Test with no network
- [ ] Test with large images
- [ ] Test with invalid images

## Future Enhancements

Potential improvements for future iterations:
1. Image cropping before upload
2. Multiple logo sizes (thumbnail, medium, large)
3. Logo history/versioning
4. Bulk update of multiple fields
5. Undo/redo functionality
6. Draft saving for updates
7. Image filters and effects
8. Logo templates

## Performance Considerations

- Images are optimized before upload (max 1024x1024, 85% quality)
- Cached network images for faster loading
- Skeleton loading for better perceived performance
- Efficient state management with BLoC
- Minimal rebuilds with proper state handling

## Security Considerations

- All endpoints require authentication
- File upload validation on server side
- Image type validation
- File size limits
- Secure token handling
- HTTPS for all API calls

## Maintenance Notes

- Keep dependencies up to date
- Monitor API response times
- Track upload success/failure rates
- Collect user feedback
- Monitor error logs
- Regular code reviews

---

**Last Updated**: May 21, 2026
**Version**: 1.0.0
**Maintained By**: Development Team
