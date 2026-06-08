# Bug Fix: Null Type Casting Error

## Issue
**Error:** `type 'Null' is not a subtype of type 'int' in type cast`

This error occurred when viewing property details for certain properties where the API response had missing or null fields.

## Root Cause Analysis

Looking at the API responses, the issue was in two places:

1. **PropertyImageModel** - The images array in the API response didn't include:
   - `property_id` field
   - `created_at` field  
   - `updated_at` field
   
   But the model was trying to cast them as required `int` values without null safety.

2. **PrimaryImageModel** - Similar issue where `id` and `property_id` were being cast as non-nullable `int` but could be null in the API response.

### API Response Structure
```json
"images": [
  {
    "id": 455,
    "image_path": "properties/images/...",
    "image_url": "https://...",
    "is_primary": true,
    "order": 0
    // NOTE: No property_id, created_at, or updated_at!
  }
]
```

## Fixes Applied

### 1. PropertyImageModel (`property_details_model.dart`)
**Before:**
```dart
factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
  return PropertyImageModel(
    id: json['id'] as int,  // ❌ Could fail if null
    propertyId: json['property_id'] as int,  // ❌ Field doesn't exist in API
    imagePath: json['image_path'] as String? ?? '',
    isPrimary: json['is_primary'] as bool? ?? false,
    order: json['order'] as int? ?? 0,
    createdAt: json['created_at'] as String? ?? '',
    updatedAt: json['updated_at'] as String? ?? '',
  );
}
```

**After:**
```dart
factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
  return PropertyImageModel(
    id: json['id'] as int? ?? 0,  // ✅ Nullable with default
    propertyId: json['property_id'] as int? ?? 0,  // ✅ Nullable with default
    imagePath: json['image_path'] as String? ?? '',
    isPrimary: json['is_primary'] as bool? ?? false,
    order: json['order'] as int? ?? 0,
    createdAt: json['created_at'] as String? ?? '',
    updatedAt: json['updated_at'] as String? ?? '',
  );
}
```

### 2. PrimaryImageModel (`property_model.dart`)
**Before:**
```dart
factory PrimaryImageModel.fromJson(Map<String, dynamic> json) {
  return PrimaryImageModel(
    id: json['id'] as int,  // ❌ Could fail if null
    propertyId: json['property_id'] as int,  // ❌ Could fail if null
    imagePath: json['image_path'] as String? ?? '',
  );
}
```

**After:**
```dart
factory PrimaryImageModel.fromJson(Map<String, dynamic> json) {
  return PrimaryImageModel(
    id: json['id'] as int? ?? 0,  // ✅ Nullable with default
    propertyId: json['property_id'] as int? ?? 0,  // ✅ Nullable with default
    imagePath: json['image_path'] as String? ?? '',
  );
}
```

### 3. Minor Cleanup
- Removed unused `import 'package:intl/intl.dart';` from `property_card.dart`

## Testing

The fix should now handle:
- Properties with images that don't include all fields
- Properties with null `id` values in images
- Properties with missing `property_id` in image data
- Properties with missing timestamp fields

## Default Values

When fields are missing from the API:
- `id`: defaults to `0`
- `propertyId`: defaults to `0`
- `imagePath`: defaults to empty string `''`
- `isPrimary`: defaults to `false`
- `order`: defaults to `0`
- `createdAt`: defaults to empty string `''`
- `updatedAt`: defaults to empty string `''`

## Prevention

To prevent similar issues in the future:
1. Always use nullable casting (`as int?`) for API fields that might be null
2. Provide sensible defaults with the null-coalescing operator (`??`)
3. Test with various API responses, especially edge cases
4. Consider using code generation tools like `json_serializable` for more robust parsing

## Related Files Modified
- `/lib/features/properties/data/models/property_details_model.dart`
- `/lib/features/properties/data/models/property_model.dart`
- `/lib/features/properties/presentation/widgets/property_card.dart`
