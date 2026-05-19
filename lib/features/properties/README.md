# Properties Feature

## Overview
The properties feature displays a list of real estate properties with pagination support.

## API Endpoint
- **URL**: `public/properties`
- **Method**: GET
- **Query Parameters**:
  - `page`: Page number (default: 1)
  - `per_page`: Items per page (default: 20)

## Response Structure
```json
{
  "success": true,
  "message": "تم جلب العقارات بنجاح",
  "data": [
    {
      "id": 91,
      "office_id": 11,
      "property_type_id": 4,
      "offer_type_id": 1,
      "title": "أرض سكنية للبيع في حي المركز - البيضاء",
      "description": "قطعة أرض سكنية في منطقة هادئة...",
      "reference_number": "AQ-2026-091",
      "price": "178000000.00",
      "currency_id": null,
      "price_negotiable": false,
      "governorate_id": 14,
      "district_id": 62,
      "neighborhood_id": 129,
      "address": "شارع التجاري، حي المركز",
      "latitude": "34.44000000",
      "longitude": "47.08000000",
      "status": "available",
      "views_count": 708,
      "published_at": "2026-04-15T10:38:37.000000Z",
      "office": {
        "id": 11,
        "name": "شركة الوفاء العقارية",
        "slug": "shrk-alofaaa-alaakary"
      },
      "property_type": {
        "id": 4,
        "name": "أرض سكنية"
      },
      "offer_type": {
        "id": 1,
        "name": "للبيع"
      },
      "governorate": {
        "id": 14,
        "name_ar": "البيضاء"
      },
      "district": {
        "id": 62,
        "name_ar": "رداع"
      },
      "neighborhood": {
        "id": 129,
        "name_ar": "حي المركز"
      },
      "primary_image": {
        "id": 434,
        "property_id": 91,
        "image_path": "properties/property-91-image-0.jpg"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 20,
    "total": 53
  }
}
```

## Architecture

### Domain Layer
- **Entities**: `PropertyEntity`, `PropertiesResponseEntity`, `PaginationMeta`
- **Repository**: `PropertiesRepository` (abstract)
- **Use Cases**: `GetPropertiesUseCase`

### Data Layer
- **Models**: `PropertyModel`, `PropertiesResponseModel`
- **Data Sources**: `PropertiesRemoteDataSource`
- **Repository Implementation**: `PropertiesRepositoryImpl`

### Presentation Layer
- **Cubit**: `PropertiesCubit` with states:
  - `PropertiesInitial`
  - `PropertiesLoading`
  - `PropertiesSuccess`
  - `PropertiesError`
  - `PropertiesLoadMoreError`
- **Screens**: `PropertiesScreen`
- **Widgets**: `PropertyCard`

## Features

### 1. Property List Display
- Shows properties in a scrollable list
- Each property card displays:
  - Property image
  - Title
  - Property type
  - Location (neighborhood, district, governorate)
  - Price (formatted with thousands separator)
  - Price negotiability indicator
  - Office name
  - Views count
  - Offer type badge (للبيع/للإيجار)

### 2. Pagination
- Automatic load more when scrolling to 90% of the list
- Shows loading indicator while fetching more data
- Displays current page and total pages
- Shows total properties count

### 3. Pull to Refresh
- Swipe down to refresh the list
- Resets to page 1 and clears existing data

### 4. Error Handling
- Network error handling
- Load more error handling (with auto-recovery)
- Retry button for initial load errors

### 5. Image Handling
- Uses cached network images for performance
- Constructs full image URLs from relative paths
- Fallback placeholder for missing images

## Usage

### 1. Add to Dependency Injection
You need to register the dependencies in your DI container:

```dart
// Data Source
sl.registerLazySingleton<PropertiesRemoteDataSource>(
  () => PropertiesRemoteDataSourceImpl(apiConsumer: sl()),
);

// Repository
sl.registerLazySingleton<PropertiesRepository>(
  () => PropertiesRepositoryImpl(
    remoteDataSource: sl(),
    networkInfo: sl(),
  ),
);

// Use Case
sl.registerLazySingleton(() => GetPropertiesUseCase(repository: sl()));

// Cubit
sl.registerFactory(() => PropertiesCubit(getPropertiesUseCase: sl()));
```

### 2. Use in Widget Tree
```dart
BlocProvider(
  create: (context) => sl<PropertiesCubit>(),
  child: const PropertiesScreen(),
)
```

### 3. Navigate to Properties Screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => sl<PropertiesCubit>(),
      child: const PropertiesScreen(),
    ),
  ),
);
```

## Image URL Construction
Images are stored on the server at: `https://dalil-alaqar.codebrains.net/storage/`

The API returns relative paths like: `properties/property-91-image-0.jpg`

The app constructs full URLs: `https://dalil-alaqar.codebrains.net/storage/properties/property-91-image-0.jpg`

## Price Formatting
Prices are formatted with Arabic thousands separator:
- Input: `"178000000.00"`
- Output: `"178,000,000 ريال"`

## Future Enhancements
- [ ] Property details screen
- [ ] Filtering by property type, offer type, location
- [ ] Sorting options (price, date, views)
- [ ] Search functionality
- [ ] Favorites/bookmarks
- [ ] Map view
- [ ] Share property
- [ ] Contact office directly
