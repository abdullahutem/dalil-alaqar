# Update Property - Quick Start Guide

## Quick Integration (5 Minutes)

### Step 1: Add Edit Button to Property Details

Open `property_details_mobile_layout.dart` and add the import:

```dart
import '../widgets/edit_property_button.dart';
```

Then add the floating action button to your Scaffold:

```dart
return Scaffold(
  floatingActionButton: EditPropertyButton(property: property),
  body: // ... existing body
);
```

### Step 2: Test the Feature

1. Run the app
2. Navigate to any property details page
3. Click the "تعديل العقار" (Edit Property) floating button
4. Update any field (e.g., change the title)
5. Click "تحديث العقار" (Update Property)
6. Verify success message appears
7. Verify you're navigated back to property details
8. Verify property details are refreshed with new data

## Example: Complete Property Details Integration

```dart
class _PropertyView extends StatelessWidget {
  final PropertyDetailsEntity property;

  const _PropertyView({required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: EditPropertyButton(property: property),
      body: CustomScrollView(
        // ... your existing scrollview content
      ),
    );
  }
}
```

## What Fields Can Be Updated?

Currently supported fields:
- ✅ Title (العنوان)
- ✅ Property Type (نوع العقار)
- ✅ Offer Type (نوع العرض)
- ✅ Description (الوصف)
- ✅ Governorate (المحافظة)
- ✅ Price (السعر)

## API Call Example

The cubit handles the API call automatically, but here's what happens under the hood:

```
PUT /office/properties/107
Content-Type: application/json
Authorization: Bearer {token}

{
  "title": "شقة للبيع في صنعاء - محدث",
  "property_type_id": 2,
  "offer_type_id": 2,
  "description": "فيلا دورين...",
  "governorate_id": 1,
  "price": 55000000
}
```

Response:
```json
{
  "success": true,
  "message": "تم تحديث العقار بنجاح",
  "data": { /* updated property object */ }
}
```

## Troubleshooting

### Edit button doesn't appear
- Make sure you imported `EditPropertyButton`
- Verify the property object is not null
- Check that you added it to the Scaffold

### Update fails with error
- Check network connectivity
- Verify authentication token is valid
- Check API logs for specific error message
- Ensure property ID exists in database

### Form doesn't pre-fill
- Verify `PropertyDetailsEntity` has the property data
- Check that property fields are not null
- Review console for any errors

### Changes not reflected after update
- The edit button widget automatically refreshes the property details
- If using custom navigation, manually call:
  ```dart
  context.read<PropertyDetailsCubit>().getPropertyDetails(propertyId);
  ```

## Common Customizations

### Change Button Position
```dart
floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
```

### Customize Button Style
Modify `edit_property_button.dart`:
```dart
FloatingActionButton.extended(
  backgroundColor: Colors.blue, // Your color
  icon: const Icon(Icons.edit_outlined), // Your icon
  label: const Text('تحرير'), // Your label
  // ...
)
```

### Add Button to Tablet Layout

Open `property_details_tablet_layout.dart`:
```dart
floatingActionButton: EditPropertyButton(property: property),
```

## Next Steps

After basic integration:
1. ✅ Add edit button to tablet layout
2. ✅ Customize button styling to match your theme
3. ✅ Add permission checks if needed
4. ✅ Consider adding confirmation dialog before navigation
5. ✅ Add analytics tracking for edit actions

## Additional Resources

- Full documentation: `UPDATE_PROPERTY_FEATURE.md`
- API documentation: Check backend API docs
- Related features:
  - Create Property: `CREATE_PROPERTY_FEATURE_PLAN.md`
  - Upload Images: `UPLOAD_IMAGES_FEATURE.md`
  - Update Status: `UPDATE_STATUS_FEATURE.md`
