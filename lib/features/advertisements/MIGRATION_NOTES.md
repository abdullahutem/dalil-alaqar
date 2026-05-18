# Advertisement Feature Migration Notes

## Overview
Updated the advertisements feature to work with the new API endpoint structure from `public/advertisements`.

## API Changes

### Old Structure
The old structure expected:
```json
{
  "data": {
    "slides": [...],
    "count": 10
  }
}
```

### New Structure
The new API returns:
```json
{
  "success": true,
  "message": "تم جلب الإعلانات بنجاح",
  "data": [
    {
      "id": 1,
      "title": "عروض حصرية على الشقق السكنية في بغداد",
      "description": "خصومات تصل إلى 15% على الشقق الجديدة",
      "image": "advertisements/banner-apartments-baghdad.jpg",
      "link": "https://dalilaqar.iq/offers/apartments",
      "position": "home_top",
      "order": 1,
      "office_id": 1,
      "start_date": "2026-05-13T00:00:00.000000Z",
      "end_date": "2026-08-18T00:00:00.000000Z",
      "views_count": 1680,
      "clicks_count": 83,
      "is_active": true,
      "status": "active",
      "created_at": "2026-05-18T10:38:37.000000Z",
      "updated_at": "2026-05-18T10:38:37.000000Z"
    }
  ]
}
```

## Changes Made

### 1. Domain Layer
**File**: `domain/entities/slide_entity.dart`
- Replaced multi-language fields (titleAr, titleEn, etc.) with single fields
- Added new fields from API: id, position, order, office_id, dates, counts, status
- **Important**: `officeId` is nullable because some ads (like registration promotions) are not tied to a specific office
- New fields:
  - `id`: Advertisement ID
  - `title`: Single title (Arabic from API)
  - `description`: Single description (Arabic from API)
  - `image`: Relative image path
  - `link`: External link URL
  - `position`: Display position (home_top, home_middle, etc.)
  - `order`: Display order
  - `officeId`: Associated office ID (nullable - can be null for platform-wide ads)
  - `startDate`, `endDate`: Campaign dates
  - `viewsCount`, `clicksCount`: Analytics
  - `isActive`: Active status
  - `status`: Status string
  - `createdAt`, `updatedAt`: Timestamps

### 2. Data Layer

#### Models
**File**: `data/models/slide_model.dart`
- Updated `fromJson` to parse new API structure
- Updated `toJson` to match new structure
- All field mappings updated (e.g., `office_id` → `officeId`)

#### Remote Data Source
**File**: `data/datasources/slider_remote_data_source.dart`
- Updated to handle new response structure
- Extracts `data` array directly (not nested in object)
- Wraps in expected format: `{slides: [...], count: length}`

#### Local Data Source
**File**: `data/datasources/slider_local_data_source.dart`
- Updated cache methods to use new field names
- Updated database column mappings
- Boolean `is_active` stored as INTEGER (0/1)

### 3. Database Schema
**File**: `core/databases/local/database_helper.dart`
- Updated database version from 1 to 2
- Added migration in `_onUpgrade` to drop old table and create new one
- New table schema matches API structure
- Added all new columns with proper types

### 4. Presentation Layer
**File**: `presentation/widgets/slider_widget.dart`
- Removed localization logic (no longer needed)
- Updated to use `slide.title` and `slide.description` directly
- Added image URL construction:
  - Checks if image starts with 'http'
  - If not, prepends: `https://dalil-alaqar.codebrains.net/storage/`
- Removed unused `AppLocalizations` import
- Added `maxLines` and `overflow` to description text

## Image URL Handling

The API returns relative paths like `"advertisements/banner-apartments-baghdad.jpg"`.

The widget constructs full URLs:
```dart
final imageUrl = slide.image.startsWith('http')
    ? slide.image
    : 'https://dalil-alaqar.codebrains.net/storage/${slide.image}';
```

This allows for both relative and absolute URLs.

## Breaking Changes

1. **No more multi-language support**: The API now returns single-language content (Arabic)
2. **Database migration**: Existing cached data will be cleared on first run
3. **Field name changes**: All old field names are replaced
4. **Nullable office_id**: The `office_id` field is now nullable to support platform-wide advertisements that are not tied to a specific office

## Testing Recommendations

1. Test with fresh install (no cached data)
2. Test with existing cached data (migration)
3. Verify image URLs are constructed correctly
4. Test offline mode (cached data)
5. Verify carousel displays correctly with new data structure

## Notes

- The API returns Arabic content only in `title` and `description` fields
- Images are stored in the `storage/advertisements/` directory on the server
- The `position` field can be used for filtering ads by location (home_top, home_middle, etc.)
- Analytics fields (`views_count`, `clicks_count`) are available for future features
