# Office Details Feature

## Overview
The Office Details feature displays comprehensive information about a real estate office, including contact details, statistics, subscription information, and recent properties.

## Architecture
This feature follows Clean Architecture principles with three main layers:

### 1. Domain Layer (`domain/`)
- **Entities**: Core business objects
  - `OfficeDetailsEntity`: Main office details container
  - `GovernorateInfo`: Governorate information
  - `DistrictInfo`: District information
  - `RecentPropertyInfo`: Recent property details
  - `PropertyTypeInfo`: Property type information
  - `OfferTypeInfo`: Offer type information
  - `PrimaryImageInfo`: Property image information

- **Repositories**: Abstract repository interface
  - `OfficeDetailsRepository`: Defines contract for data operations

- **Use Cases**: Business logic
  - `GetOfficeDetailsUseCase`: Fetches office details by ID

### 2. Data Layer (`data/`)
- **Models**: Data transfer objects with JSON serialization
  - `OfficeDetailsModel`: Extends `OfficeDetailsEntity` with `fromJson`
  - All nested models with JSON parsing

- **Data Sources**: API communication
  - `OfficeDetailsRemoteDataSource`: Interface for remote data operations
  - `OfficeDetailsRemoteDataSourceImpl`: Implementation using API consumer

- **Repositories**: Implementation of domain repositories
  - `OfficeDetailsRepositoryImpl`: Implements `OfficeDetailsRepository` with network handling

### 3. Presentation Layer (`presentation/`)
- **Cubit**: State management
  - `OfficeDetailsCubit`: Manages office details state and business logic
  - `OfficeDetailsState`: State definitions (Initial, Loading, Success, Error)

- **Screens**: UI screens (Responsive)
  - `OfficeDetailsScreen`: Main screen with responsive layout switching
  - `OfficeDetailsMobileLayout`: Mobile-optimized layout
  - `OfficeDetailsTabletLayout`: Tablet-optimized layout (2-column)

- **Widgets**: Reusable UI components
  - `OfficeHeaderSection`: Office name, owner, rating, description
  - `OfficeStatsSection`: Statistics cards (properties, views, subscription)
  - `OfficeInfoSection`: Detailed office information
  - `OfficeContactSection`: Contact buttons and social media
  - `OfficePropertiesSection`: Recent properties list

## API Endpoint

### Get Office Details
**Endpoint**: `public/offices/{id}`  
**Method**: GET  
**Authentication**: Not required

**Response Structure**:
```json
{
  "success": true,
  "message": "تم جلب تفاصيل المكتب بنجاح",
  "data": {
    "id": 1,
    "name": "مكتب دار السلام العقاري",
    "owner_name": "أحمد محمد العبيدي",
    "slug": "mktb-dar-alslam-alaakary",
    "logo": null,
    "email": "office@example.com",
    "phone": "+96477693354520",
    "mobile_phone": "+96475571972606",
    "whatsapp_number": "+96477491521692",
    "commercial_license": "IQ-2026-00001",
    "description": "...",
    "rating": "3.80",
    "total_ratings": 72,
    "total_properties": 8,
    "total_views": 3623,
    "subscription_type": "الباقة الأساسية",
    "max_properties": 30,
    "is_verified": true,
    "governorate": {...},
    "district": {...},
    "recent_properties": [...]
  }
}
```

## Features

### 1. **Office Header**
- Office name with verification badge
- Owner name
- Location (governorate and district)
- Star rating with total ratings count
- Full description

### 2. **Statistics Cards**
- Total properties count
- Total views count
- Subscription type
- Maximum properties limit

### 3. **Office Information**
- Commercial license number
- License number (if available)
- Full address
- Join date
- Verification date
- Subscription start and end dates

### 4. **Contact Section**
- Phone number (clickable to call)
- Mobile phone (clickable to call)
- WhatsApp (clickable to open chat)
- Email (clickable to send email)
- Social media links (website, Facebook, Instagram, Twitter)

### 5. **Recent Properties**
- List of recent properties with:
  - Property image
  - Title
  - Property type and offer type
  - Price
  - Views count
  - Status badge

### 6. **Responsive Design**
- **Mobile Layout**: Single column, floating action buttons
- **Tablet Layout**: Two-column layout, extended action buttons
- Breakpoint: 600px width

### 7. **Dark Mode Support**
- Automatic theme detection
- Proper colors for dark and light modes
- Consistent styling across themes

### 8. **Floating Action Buttons**
- **Mobile**: Stacked FABs (Call, WhatsApp)
- **Tablet**: Extended FABs with labels

## Usage

### Basic Navigation

```dart
import 'package:dalil_alaqar/features/office_details/presentation/screens/office_details_screen.dart';

// Navigate to office details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OfficeDetailsScreen(officeId: 1),
  ),
);
```

### With Named Routes

```dart
// In your routes configuration
'/office-details': (context) {
  final officeId = ModalRoute.of(context)!.settings.arguments as int;
  return OfficeDetailsScreen(officeId: officeId);
},

// Navigate
Navigator.pushNamed(
  context,
  '/office-details',
  arguments: 1,
);
```

## UI Components

### Office Header Section
- Displays office name, owner, location, rating, and description
- Shows verification badge if office is verified
- Supports dark mode

### Office Stats Section
- 4 stat cards in 2x2 grid
- Color-coded icons
- Responsive sizing

### Office Info Section
- Detailed information with icons
- Date formatting
- Conditional rendering for optional fields

### Office Contact Section
- Clickable contact buttons
- Social media icons
- URL launching for phone, email, WhatsApp, and websites

### Office Properties Section
- Horizontal property cards
- Property images with fallback
- Status badges with colors
- Clickable cards for navigation

## Dependencies

Required packages:
- `flutter_bloc`: State management
- `dartz`: Functional programming (Either type)
- `dio`: HTTP client
- `data_connection_checker_tv`: Network connectivity
- `url_launcher`: Launch URLs (phone, email, web, WhatsApp)

## Responsive Breakpoints

- **Mobile**: < 600px width
  - Single column layout
  - Stacked floating action buttons
  - Compact spacing

- **Tablet**: >= 600px width
  - Two-column layout (2:1 ratio)
  - Extended floating action buttons
  - Wider spacing

## Dark Mode

The feature automatically detects the system theme and applies appropriate colors:

- **Light Mode**:
  - Background: Grey[50]
  - Cards: White
  - Text: Black87/Grey[800]

- **Dark Mode**:
  - Background: Grey[900]
  - Cards: Grey[850]
  - Text: White/Grey[300]

## Error Handling

The feature handles various error scenarios:
- Network errors
- API errors
- Invalid office ID
- Missing data

All errors are displayed with:
- Error icon
- Error message
- Back button

## State Management

### States
1. **OfficeDetailsInitial**: Initial state before loading
2. **OfficeDetailsLoading**: Loading data from API
3. **OfficeDetailsSuccess**: Data loaded successfully
4. **OfficeDetailsError**: Error occurred during loading

### State Flow
```
Initial → Loading → Success/Error
```

## Customization

### Changing Colors
Edit the color scheme in widgets:
- Stats cards: Modify color parameters
- Contact buttons: Update color values
- Status badges: Edit `_getStatusColor()` method

### Adding New Sections
1. Create new widget in `widgets/` directory
2. Add to mobile and tablet layouts
3. Update entity and model if needed

### Modifying Layout
- Mobile: Edit `office_details_mobile_layout.dart`
- Tablet: Edit `office_details_tablet_layout.dart`
- Adjust breakpoint in `office_details_screen.dart`

## File Structure

```
office_details/
├── data/
│   ├── datasources/
│   │   └── office_details_remote_data_source.dart
│   ├── models/
│   │   └── office_details_model.dart
│   └── repositories/
│       └── office_details_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── office_details_entity.dart
│   ├── repositories/
│   │   └── office_details_repository.dart
│   └── usecases/
│       └── get_office_details_usecase.dart
├── presentation/
│   ├── cubit/
│   │   ├── office_details_cubit.dart
│   │   └── office_details_state.dart
│   ├── screens/
│   │   ├── office_details_screen.dart
│   │   ├── office_details_mobile_layout.dart
│   │   └── office_details_tablet_layout.dart
│   └── widgets/
│       ├── office_header_section.dart
│       ├── office_stats_section.dart
│       ├── office_info_section.dart
│       ├── office_contact_section.dart
│       └── office_properties_section.dart
└── README.md
```

**Total Files Created: 16**

## Testing

### Test Scenarios:

1. **Loading State**:
   - Open office details
   - Should show loading indicator

2. **Success State**:
   - Data loads successfully
   - All sections display correctly
   - Images load or show placeholders

3. **Error State**:
   - Invalid office ID
   - Network error
   - Should show error message and back button

4. **Responsive Design**:
   - Test on mobile (< 600px)
   - Test on tablet (>= 600px)
   - Layout should adapt correctly

5. **Dark Mode**:
   - Switch to dark mode
   - All colors should adapt
   - Text should remain readable

6. **Contact Actions**:
   - Tap phone button → Should open dialer
   - Tap WhatsApp → Should open WhatsApp
   - Tap email → Should open email client
   - Tap social media → Should open browser

## Performance Considerations

1. **Lazy Loading**: Office details load only when accessed
2. **Image Caching**: Network images are cached automatically
3. **Efficient Rendering**: Responsive layout switching
4. **Error Boundaries**: Graceful error handling

## Future Enhancements

Potential improvements:
1. Add office reviews and ratings section
2. Implement property filtering
3. Add map view for office location
4. Add share office functionality
5. Implement favorite/bookmark feature
6. Add office comparison feature
7. Add office working hours
8. Add office gallery/photos

## Troubleshooting

### Office details not loading
- Check office ID is valid
- Verify API endpoint configuration
- Check network connectivity
- Review API response format

### Images not displaying
- Check image URLs are valid
- Verify network connection
- Ensure placeholder is showing

### Contact buttons not working
- Verify `url_launcher` package is installed
- Check URL schemes are configured (iOS)
- Test on physical device (not simulator)

---

**Status**: ✅ **COMPLETE AND READY FOR USE**

The Office Details feature is fully implemented with responsive design, dark mode support, and comprehensive functionality.
