# Create Property - Quick Start Guide

## ✅ Completed So Far

**Backend (Phase 1)** ✅ DONE
- Entity, Model, UseCase
- Data Source, Repository
- API integration

**State Management (Phase 2)** ✅ DONE  
- Cubit with validation
- 5 state types
- Form validator utility

## 🎯 Next: UI Implementation (Phase 3)

### Step 1: Install Dependencies (5 minutes)

Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  geolocator: ^13.0.2
```

Run: `flutter pub get`

### Step 2: Configure Permissions (5 minutes)

**Android** - `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**iOS** - `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>نحتاج إلى موقعك لتحديد موقع العقار</string>
```

### Step 3: What to Build

#### Core Files (Must Have):
1. `presentation/cubit/property_location_cubit.dart` - Map state
2. `presentation/cubit/property_location_state.dart` - Location states
3. `presentation/screens/create_property_screen.dart` - Main screen
4. `presentation/widgets/property_location_picker.dart` - Map widget

#### Nice to Have:
5. `presentation/widgets/property_form_field.dart` - Styled input
6. `presentation/widgets/geographic_selection_widget.dart` - Cascading dropdowns
7. Step widgets (basic_info, price, location, review)

### Step 4: Quick Implementation

**Option A - Simple Form (2-3 hours)**
- Single page with all fields
- Basic map or manual lat/lon
- Good for testing backend

**Option B - Full Featured (15 hours)** ⭐ Recommended
- 4-step wizard
- Interactive map
- Complete UX
- Production ready

### Step 5: Key Code Snippets

**Location Cubit Core:**
```dart
class PropertyLocationCubit extends Cubit<PropertyLocationState> {
  LatLng currentPosition = const LatLng(15.3694, 44.1910);
  
  Future<void> requestLocationPermission() { /* impl */ }
  Future<void> updateMapPosition(LatLng pos) { /* impl */ }
  Future<void> _reverseGeocode(LatLng pos) { /* impl */ }
}
```

**Map Widget:**
```dart
FlutterMap(
  options: MapOptions(
    onTap: (_, point) => locationCubit.updateMapPosition(point),
  ),
  children: [
    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
    MarkerLayer(markers: [/* marker at position */]),
  ],
)
```

**Submit Property:**
```dart
final property = CreatePropertyEntity(
  propertyTypeId: selectedPropertyType,
  offerTypeId: selectedOfferType,
  title: titleController.text,
  // ... other fields
  latitude: locationCubit.currentPosition.latitude,
  longitude: locationCubit.currentPosition.longitude,
);

context.read<CreatePropertyCubit>().createProperty(property);
```

## 📚 Full Documentation

| Document | Use For |
|----------|---------|
| `DEPENDENCIES_NEEDED.md` | Setup dependencies & permissions |
| `CREATE_PROPERTY_IMPLEMENTATION_GUIDE.md` | Step-by-step implementation |
| `CREATE_PROPERTY_SUMMARY.md` | Overall status & architecture |
| `CREATE_PROPERTY_FEATURE_PLAN.md` | Original planning |
| `map_location_implementation_prompt.md` | Map integration details |

## 🚀 Fastest Path to Working Feature

1. Install dependencies (5 min)
2. Create simple PropertyLocationCubit (30 min)
3. Create basic form screen with all fields (2 hours)
4. Add map widget (1 hour)
5. Wire everything together (30 min)
6. Test & fix (1 hour)

**Total: ~5 hours for basic working version**

## 💡 Tips

- Start simple, enhance later
- Test location permissions on real device
- Use existing app widgets/styles
- Validate each step before moving on
- Keep backend/state management as-is (already done)

## ✨ Success = Property Created + Images Uploadable

The minimum viable feature:
- ✅ Form collects all required data
- ✅ Location selected (map or manual)
- ✅ API call creates property
- ✅ Navigate to property details
- ✅ Can upload images to new property

Everything else is polish! 🎨
