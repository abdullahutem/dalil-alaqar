# Property Details Feature

## Overview
This document describes the Property Details feature implementation, which displays comprehensive information about a single property including images, location, price, and office contact details.

## Architecture

The feature follows Clean Architecture principles with three layers:

### 1. Domain Layer
- **Entity**: `PropertyDetailsEntity` - Contains all property information including nested objects for office, location, and images
- **Repository Interface**: `PropertiesRepository` - Defines the contract for data operations
- **Use Case**: `GetPropertyDetailsUseCase` - Encapsulates the business logic for fetching property details

### 2. Data Layer
- **Model**: `PropertyDetailsModel` - Implements the entity and handles JSON serialization
- **Data Source**: `PropertiesRemoteDataSource` - Handles API communication
- **Repository Implementation**: `PropertiesRepositoryImpl` - Implements the repository interface

### 3. Presentation Layer
- **Cubit**: `PropertyDetailsCubit` - Manages state and business logic
- **States**: `PropertyDetailsState` - Defines all possible UI states (Initial, Loading, Success, Error)
- **Screens**: 
  - `PropertyDetailsScreen` - Main screen with responsive layout switching
  - `PropertyDetailsMobileLayout` - Mobile-optimized layout
  - `PropertyDetailsTabletLayout` - Tablet-optimized layout
- **Widgets**:
  - `PropertyImageGallery` - Image carousel with full-screen viewer
  - `PropertyDetailsContent` - Main content display with all property information

## API Integration

### Endpoint
```
GET /api/public/properties/{id}
```

### Response Structure
```json
{
  "success": true,
  "message": "تم جلب تفاصيل العقار بنجاح",
  "data": {
    "id": 1,
    "title": "فيلا للبيع في حي السلام - ذمار",
    "description": "...",
    "price": "729000000.00",
    "price_negotiable": true,
    "images": [...],
    "office": {...},
    "property_type": {...},
    "governorate": {...},
    ...
  }
}
```

## Features

### 1. Image Gallery
- **Swipeable carousel** with page indicators
- **Full-screen viewer** with pinch-to-zoom
- **Navigation arrows** on tablet/desktop
- **Placeholder** for missing images
- **Cached images** for better performance

### 2. Property Information
- **Title and reference number** with badges
- **Price display** with formatting and negotiable indicator
- **Property type and offer type** (للبيع/للإيجار)
- **Status badge** (متاح/غير متاح)
- **View count** and publication date

### 3. Location Details
- **Hierarchical location** (Governorate → District → Neighborhood)
- **Full address** display
- **Google Maps integration** - Opens location in Google Maps
- **Coordinates** for precise location

### 4. Office Information
- **Office name** and contact details
- **Phone number** with direct call functionality
- **WhatsApp number** with direct messaging
- **Email address**

### 5. Contact Actions
- **Call button** - Opens phone dialer
- **WhatsApp button** - Opens WhatsApp chat
- **Share button** - Share property (TODO)
- **Favorite button** - Save to favorites (TODO)

## Responsive Design

### Mobile Layout (< 600px)
- **Vertical scrolling** with collapsible app bar
- **Full-width image gallery** at the top
- **Stacked content** sections
- **Floating action buttons** for share and favorite

### Tablet Layout (≥ 600px)
- **Two-column layout** (60/40 split)
- **Fixed image gallery** on the left
- **Scrollable details** on the right
- **Standard app bar** with actions

## Theme Support

### Light Mode
- White/light gray backgrounds
- Dark text on light surfaces
- Primary color accents
- Subtle shadows and borders

### Dark Mode
- Dark gray/black backgrounds
- Light text on dark surfaces
- Primary color accents
- Reduced shadows, prominent borders

## Color Scheme
- **Primary**: `#038086` (Teal)
- **Success**: `#4CAF50` (Green) - for WhatsApp and status
- **Error**: `#CF6679` (Red) - for error states
- **Light Background**: `#F8F9FA`
- **Dark Background**: `#121212`
- **Light Surface**: `#FFFFFF`
- **Dark Surface**: `#1E1E1E`

## Dependencies

### Required Packages
```yaml
dependencies:
  flutter_bloc: ^9.1.1          # State management
  cached_network_image: ^3.4.1  # Image caching
  url_launcher: ^6.3.1          # Phone/WhatsApp/Maps
  get_it: ^8.0.3                # Dependency injection
  dartz: ^0.10.1                # Functional programming
  dio: ^5.9.2                   # HTTP client
  intl: any                     # Number/date formatting
```

## Navigation

### From Property List
```dart
// Automatic navigation from property cards
PropertyCard(property: property) // Taps navigate automatically

// Or manual navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PropertyDetailsScreen(propertyId: 1),
  ),
);
```

## State Management

### States
1. **PropertyDetailsInitial** - Initial state before loading
2. **PropertyDetailsLoading** - Showing loading indicator
3. **PropertyDetailsSuccess** - Property data loaded successfully
4. **PropertyDetailsError** - Error occurred with message

### State Flow
```
Initial → Loading → Success/Error
```

## Error Handling

### Network Errors
- No internet connection message
- Server error messages
- Timeout handling

### UI Feedback
- Loading spinner during fetch
- Error screen with retry option
- Empty state for missing images

## Future Enhancements

### TODO Items
1. **Share functionality** - Share property via social media
2. **Favorite functionality** - Save properties to favorites
3. **Similar properties** - Show related listings
4. **Property comparison** - Compare multiple properties
5. **Virtual tour** - 360° images or video tours
6. **Amenities list** - Display property features
7. **Floor plans** - Show property layout
8. **Mortgage calculator** - Calculate monthly payments
9. **Contact form** - Send inquiry to office
10. **Report listing** - Flag inappropriate content

## Testing

### Manual Testing Checklist
- [ ] Property loads correctly
- [ ] Images display and swipe works
- [ ] Full-screen gallery opens
- [ ] Phone call opens dialer
- [ ] WhatsApp opens chat
- [ ] Google Maps opens location
- [ ] Price formatting is correct
- [ ] Date formatting is correct
- [ ] Dark mode displays correctly
- [ ] Light mode displays correctly
- [ ] Tablet layout works
- [ ] Mobile layout works
- [ ] Error states display
- [ ] Loading states display
- [ ] Back navigation works

## File Structure

```
lib/features/properties/
├── domain/
│   ├── entities/
│   │   └── property_details_entity.dart
│   ├── repositories/
│   │   └── properties_repository.dart (updated)
│   └── usecases/
│       └── get_property_details_usecase.dart
├── data/
│   ├── models/
│   │   └── property_details_model.dart
│   ├── datasources/
│   │   └── properties_remote_data_source.dart (updated)
│   └── repositories/
│       └── properties_repository_impl.dart (updated)
└── presentation/
    ├── cubit/
    │   ├── property_details_cubit.dart
    │   └── property_details_state.dart
    ├── screens/
    │   ├── property_details_screen.dart
    │   ├── property_details_mobile_layout.dart
    │   └── property_details_tablet_layout.dart
    └── widgets/
        ├── property_image_gallery.dart
        └── property_details_content.dart
```

## Performance Considerations

1. **Image Caching** - Uses `cached_network_image` for efficient image loading
2. **Lazy Loading** - Images load on demand
3. **State Management** - Efficient state updates with BLoC
4. **Network Optimization** - Single API call for all data
5. **Memory Management** - Proper disposal of controllers

## Accessibility

1. **Semantic labels** on all interactive elements
2. **Sufficient color contrast** for text
3. **Touch targets** meet minimum size requirements
4. **Screen reader support** for all content
5. **Keyboard navigation** support (web/desktop)

## Localization

Currently supports Arabic (RTL):
- All text in Arabic
- RTL layout support
- Arabic number formatting
- Arabic date formatting

## Known Issues

None at this time.

## Version History

- **v1.0.0** (2026-05-19) - Initial implementation
  - Property details display
  - Image gallery with full-screen viewer
  - Responsive layouts (mobile/tablet)
  - Dark/light theme support
  - Contact actions (call/WhatsApp)
  - Google Maps integration
