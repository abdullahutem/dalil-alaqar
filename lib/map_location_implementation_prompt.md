# Flutter Map Location Picker Implementation Guide

## Overview
This document provides a comprehensive guide to implement an interactive map-based location picker screen in Flutter. The implementation allows users to select their delivery location by tapping on a map, with automatic address resolution via reverse geocoding, location permissions handling, and geographic region selection.

---

## Architecture Pattern
**State Management:** BLoC (Business Logic Component) pattern using flutter_bloc
**Clean Architecture:** Separation of concerns with presentation, domain, and data layers

---

## Required Dependencies

Add these packages to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Map & Location
  flutter_map: ^7.0.2  # For displaying interactive maps
  latlong2: ^0.9.1      # For handling latitude/longitude coordinates
  geolocator: ^13.0.2   # For device location permissions and GPS access
  
  # HTTP & Network
  dio: ^5.7.0           # For reverse geocoding API calls
  
  # State Management
  flutter_bloc: ^8.1.6  # For BLoC pattern
  
  # Dependency Injection
  get_it: ^8.0.3        # For service locator pattern
```

---

## Core Features to Implement

### 1. **Interactive Map Display**
- Display OpenStreetMap tiles using flutter_map
- Allow users to tap anywhere on the map to select a location
- Show a custom marker at the selected position
- Smooth map controls (zoom in/out, pan)

### 2. **Location Permissions**
- Request runtime location permissions from the user
- Handle permission granted, denied, and denied forever states
- Fallback to a default location if permissions are denied
- Get user's current GPS position when permission is granted

### 3. **Reverse Geocoding**
- Convert latitude/longitude coordinates to a human-readable address
- Use OpenStreetMap's Nominatim API for reverse geocoding
- Display the address in the address text field automatically
- Support Arabic language for addresses

### 4. **User Interface Components**
- Split screen: Map view (top 45%) + Form view (bottom 55%)
- Form fields: Location name, Address, Optional description
- Geographic dropdowns: Governorate → District → Area (hierarchical)
- Control buttons: Zoom in/out, My location button
- Instruction banner on map
- Loading states and error handling
- Save/Update button with validation

### 5. **Edit Mode Support**
- Pre-populate form fields when editing an existing location
- Initialize map position with saved coordinates
- Load saved geographic selections (governorate/district/area)

---

## Implementation Details

### State Management Structure

#### **LocationCubit** (Main Business Logic)

**Responsibilities:**
- Manage map position and coordinates
- Handle location permissions
- Perform reverse geocoding
- Save/update location to backend
- Track current address

**Key Properties:**
```dart
LatLng currentPosition = const LatLng(12.858493, 45.0030719); // Default: Yemen coordinates
bool hasLocationPermission = false;
String? currentAddress;
```

**Key Methods:**
```dart
// Initialize with existing coordinates (for edit mode)
void initializeWithLocation(double latitude, double longitude)

// Request device location permission and get GPS position
Future<void> requestLocationPermission()

// Update position when user taps on map
Future<void> updateMapPosition(LatLng position)

// Get human-readable address from coordinates
Future<void> _getAddressFromCoordinates(LatLng position)

// Save new location to backend
Future<void> addLocation({
  required String name,
  required String address,
  String? description,
  required double latitude,
  required double longitude,
  required int governorateId,
  required int districtId,
  required int areaId,
})

// Update existing location
Future<void> updateLocation({...})
```

**States to Emit:**
```dart
LocationInitial()                              // Initial state
LocationPermissionRequesting()                 // Checking permissions
LocationPermissionGranted(LatLng position)     // Permission approved + GPS position
LocationPermissionDenied(String message)       // Permission denied with error message
LocationMapPositionUpdated(LatLng, String?)    // User tapped map + new address
LocationLoading()                              // Saving to backend
LocationAdded(LocationEntity)                  // Successfully saved
LocationUpdated(LocationEntity)                // Successfully updated
LocationError(String message)                  // Error occurred
```

#### **GeographicSelectionCubit** (Geographic Regions)

**Responsibilities:**
- Manage hierarchical selection of governorate → district → area
- Reset dependent dropdowns when parent changes
- Validate complete selection before saving

**Key Methods:**
```dart
void selectGovernorate(GovernorateEntity? governorate)  // Resets district & area
void selectDistrict(DistrictEntity? district)          // Resets area only
void selectArea(AreaEntity? area)                      // Final selection
bool isComplete()                                       // Validate all selected
GeographicSelectionUpdated? getSelection()             // Get current selection
void initializeWithSelections(...)                     // For edit mode
```

---

## Screen Layout Structure

```
Scaffold
├── AppBar
│   └── Title (Dynamic: "Add Location" or "Edit Location")
│
├── Body (Column)
│   ├── Map Section (Expanded flex: 5)
│   │   ├── FlutterMap Widget
│   │   │   ├── TileLayer (OpenStreetMap)
│   │   │   └── MarkerLayer (Red pin at current position)
│   │   ├── Instruction Banner (Positioned top-left)
│   │   ├── Zoom Controls (Positioned right-top)
│   │   ├── My Location Button (Positioned right-bottom)
│   │   └── Loading Overlay (when requesting permission)
│   │
│   └── Form Section (Expanded flex: 6)
│       └── Container with rounded top corners
│           └── SingleChildScrollView
│               ├── Drag Handle (visual indicator)
│               ├── "Location Details" Title
│               ├── Name TextField (Required)
│               ├── Address TextField (Auto-filled, Required)
│               ├── "Geographic Location" Title
│               ├── Governorate Dropdown (Required)
│               ├── District Dropdown (Enabled after governorate)
│               ├── Area Dropdown (Enabled after district)
│               ├── Description TextField (Optional, multiline)
│               └── Save/Update Button
```

---

## Map Implementation Details

### FlutterMap Configuration

```dart
FlutterMap(
  mapController: _mapController,
  options: MapOptions(
    initialCenter: cubit.currentPosition,
    initialZoom: 15.0,
    minZoom: 5.0,
    maxZoom: 18.0,
    onTap: (tapPosition, point) {
      cubit.updateMapPosition(point);  // Triggers reverse geocoding
    },
  ),
  children: [
    // OpenStreetMap Tiles
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.your_app',
    ),
    
    // Marker at selected position
    MarkerLayer(
      markers: [
        Marker(
          point: cubit.currentPosition,
          width: 50,
          height: 50,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ],
)
```

### Map Control Buttons

**Zoom In/Out:**
```dart
_buildControlButton(
  icon: Icons.add,
  onTap: () {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(
      _mapController.camera.center,
      currentZoom + 1,
    );
  },
)
```

**My Location Button:**
```dart
_buildControlButton(
  icon: Icons.my_location,
  color: Colors.blue,
  onTap: () {
    if (cubit.hasLocationPermission) {
      _mapController.move(cubit.currentPosition, 15.0);
    } else {
      cubit.requestLocationPermission();
    }
  },
)
```

---

## Location Permission Flow

### Using Geolocator Package

```dart
Future<void> requestLocationPermission() async {
  emit(LocationPermissionRequesting());

  // 1. Check if location service is enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    emit(LocationPermissionDenied('Location service is disabled'));
    currentPosition = const LatLng(12.858493, 45.0030719); // Default fallback
    await _getAddressFromCoordinates(currentPosition);
    return;
  }

  // 2. Check current permission status
  LocationPermission permission = await Geolocator.checkPermission();
  
  // 3. Request permission if denied
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      emit(LocationPermissionDenied('Location permission denied'));
      currentPosition = const LatLng(12.858493, 45.0030719);
      await _getAddressFromCoordinates(currentPosition);
      return;
    }
  }

  // 4. Handle permanently denied
  if (permission == LocationPermission.deniedForever) {
    emit(LocationPermissionDenied('Location permission denied forever'));
    currentPosition = const LatLng(12.858493, 45.0030719);
    await _getAddressFromCoordinates(currentPosition);
    return;
  }

  // 5. Get current position
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = LatLng(position.latitude, position.longitude);
    hasLocationPermission = true;
    await _getAddressFromCoordinates(currentPosition);
    emit(LocationPermissionGranted(currentPosition));
  } catch (e) {
    emit(LocationPermissionDenied('Failed to get location'));
    currentPosition = const LatLng(12.858493, 45.0030719);
    await _getAddressFromCoordinates(currentPosition);
  }
}
```

**Important:** Always provide a fallback location (default coordinates) when permissions are denied.

---

## Reverse Geocoding Implementation

### Using OpenStreetMap Nominatim API

```dart
Future<void> _getAddressFromCoordinates(LatLng position) async {
  try {
    final dio = Dio();
    final response = await dio.get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {
        'format': 'json',
        'lat': position.latitude,
        'lon': position.longitude,
        'zoom': 18,
        'addressdetails': 1,
        'accept-language': 'ar',  // For Arabic addresses, use 'en' for English
      },
      options: Options(
        headers: {'User-Agent': 'YourAppName/1.0'}  // Required by Nominatim
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      currentAddress = data['display_name'] ?? 
        '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    } else {
      currentAddress = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    }
  } catch (e) {
    // Fallback to coordinates if API fails
    currentAddress = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
  }
}
```

**API Usage Notes:**
- **Rate Limiting:** Nominatim has usage limits. For production, consider self-hosting or using paid alternatives.
- **User-Agent:** Always include a User-Agent header with your app name.
- **Language:** Use `accept-language` parameter for localized addresses.

---

## Form Validation and Save Logic

### Form Structure

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      // Location Name Field
      TextFormField(
        controller: _nameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a location name';
          }
          return null;
        },
      ),
      
      // Address Field (auto-filled)
      TextFormField(
        controller: _addressController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an address';
          }
          return null;
        },
      ),
      
      // Geographic Dropdowns (required)
      GovernorateDropdown(...),
      DistrictDropdown(...),
      AreaDropdown(...),
      
      // Description Field (optional)
      TextFormField(
        controller: _descriptionController,
      ),
      
      // Save Button
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final geoSelection = context.read<GeographicSelectionCubit>().getSelection();
            
            // Validate geographic selections
            if (geoSelection == null || 
                geoSelection.governorate == null ||
                geoSelection.district == null ||
                geoSelection.area == null) {
              // Show error: "Please select governorate, district, and area"
              return;
            }
            
            // Save location
            cubit.addLocation(
              name: _nameController.text,
              address: _addressController.text,
              description: _descriptionController.text.isEmpty 
                ? null 
                : _descriptionController.text,
              latitude: cubit.currentPosition.latitude,
              longitude: cubit.currentPosition.longitude,
              governorateId: geoSelection.governorate!.id,
              districtId: geoSelection.district!.id,
              areaId: geoSelection.area!.id,
            );
          }
        },
        child: Text('Save Location'),
      ),
    ],
  ),
)
```

### Coordinate Validation

```dart
// Validate latitude and longitude before saving
if (latitude < -90 || latitude > 90) {
  emit(LocationError('Latitude must be between -90 and 90.'));
  return;
}

if (longitude < -180 || longitude > 180) {
  emit(LocationError('Longitude must be between -180 and 180.'));
  return;
}
```

---

## UI State Handling with BlocConsumer

```dart
BlocConsumer<LocationCubit, LocationState>(
  listener: (context, state) {
    // Handle state changes
    if (state is LocationPermissionGranted) {
      _mapController.move(state.position, 15.0);
      _addressController.text = context.read<LocationCubit>().currentAddress ?? '';
    } 
    else if (state is LocationPermissionDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.orange),
      );
    }
    else if (state is LocationMapPositionUpdated) {
      if (state.address != null) {
        _addressController.text = state.address!;
      }
    }
    else if (state is LocationAdded || state is LocationUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location saved successfully'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, state.location);
    }
    else if (state is LocationError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  },
  builder: (context, state) {
    // Build UI based on state
    return /* Your UI */;
  },
)
```

---

## Hierarchical Geographic Selection

### Pattern: Governorate → District → Area

**Key Behavior:**
1. Initially, only Governorate dropdown is enabled
2. When governorate is selected:
   - Fetch districts for that governorate
   - Enable District dropdown
   - Reset Area dropdown
3. When district is selected:
   - Fetch areas for that district
   - Enable Area dropdown
4. All three must be selected before saving

**Implementation:**

```dart
BlocBuilder<GeographicSelectionCubit, GeographicSelectionState>(
  builder: (context, geoState) {
    final selection = geoState is GeographicSelectionUpdated ? geoState : null;
    
    return Column(
      children: [
        // Governorate (always enabled)
        GovernorateDropdown(
          selectedGovernorate: selection?.governorate,
          onChanged: (governorate) {
            context.read<GeographicSelectionCubit>().selectGovernorate(governorate);
          },
        ),
        
        // District (enabled only if governorate selected)
        DistrictDropdown(
          selectedDistrict: selection?.district,
          governorateId: selection?.governorate?.id,
          enabled: selection?.governorate != null,
          onChanged: (district) {
            context.read<GeographicSelectionCubit>().selectDistrict(district);
          },
        ),
        
        // Area (enabled only if district selected)
        AreaDropdown(
          selectedArea: selection?.area,
          districtId: selection?.district?.id,
          enabled: selection?.district != null,
          onChanged: (area) {
            context.read<GeographicSelectionCubit>().selectArea(area);
          },
        ),
      ],
    );
  },
)
```

**When parent selection changes:**
```dart
void selectGovernorate(GovernorateEntity? governorate) {
  // Reset dependent selections
  emit(GeographicSelectionUpdated(
    governorate: governorate,
    district: null,  // Reset
    area: null,      // Reset
  ));
  
  // Trigger fetch districts for new governorate
  if (governorate != null) {
    context.read<DistrictsCubit>().fetchDistricts(governorate.id);
  }
}
```

---

## Edit Mode Support

### Initialize Screen with Existing Location

```dart
class AddLocationScreen extends StatelessWidget {
  final LocationEntity? locationToEdit;  // Null for create mode

  const AddLocationScreen({super.key, this.locationToEdit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = GetIt.instance<LocationCubit>();
            
            // If editing, initialize with saved coordinates
            if (locationToEdit != null) {
              cubit.initializeWithLocation(
                locationToEdit!.latitude,
                locationToEdit!.longitude,
              );
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = GeographicSelectionCubit();
            
            // If editing, pre-populate geographic selections
            if (locationToEdit != null &&
                locationToEdit!.governorate != null &&
                locationToEdit!.district != null &&
                locationToEdit!.area != null) {
              cubit.initializeWithSelections(
                governorate: locationToEdit!.governorate!,
                district: locationToEdit!.district!,
                area: locationToEdit!.area!,
              );
            }
            return cubit;
          },
        ),
      ],
      child: _AddLocationScreenContent(locationToEdit: locationToEdit),
    );
  }
}
```

### Pre-fill Form Fields

```dart
@override
void initState() {
  super.initState();
  
  // Pre-fill text fields if editing
  if (widget.locationToEdit != null) {
    _nameController.text = widget.locationToEdit!.name;
    _addressController.text = widget.locationToEdit!.address;
    _descriptionController.text = widget.locationToEdit!.description ?? '';
  }
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Request location permission only for new locations
    if (widget.locationToEdit == null) {
      context.read<LocationCubit>().requestLocationPermission();
    }
    
    // Fetch governorates for dropdown
    context.read<GovernoratesCubit>().fetchGovernorates();
    
    // If editing, fetch dependent data
    if (widget.locationToEdit != null) {
      if (widget.locationToEdit!.governorate != null) {
        context.read<DistrictsCubit>().fetchDistricts(
          widget.locationToEdit!.governorate!.id,
        );
      }
      if (widget.locationToEdit!.district != null) {
        context.read<AreasCubit>().fetchAreas(
          widget.locationToEdit!.district!.id,
        );
      }
    }
  });
}
```

---

## Design & Styling Guidelines

### Color Scheme
- **Primary Color:** Define in `AppColors.primary`
- **Background:** `Colors.grey[50]`
- **Cards/Forms:** White with rounded corners
- **Shadows:** Subtle `Colors.black.withOpacity(0.1)`

### UI Elements

**Rounded Containers:**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
)
```

**Text Fields:**
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(icon, color: AppColors.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: Colors.grey[50],
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
)
```

**Buttons:**
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 2,
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.save, size: 20),
      SizedBox(width: 8),
      Text('Save Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ],
  ),
)
```

### Accessibility Features

**Loading States:**
```dart
if (state is LocationLoading)
  SizedBox(
    height: 24,
    width: 24,
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2.5,
    ),
  )
```

**SnackBars with Icons:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 12),
        Expanded(child: Text('Success message')),
      ],
    ),
    backgroundColor: Colors.green[600],
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

---

## Multi-Language Support

### Using Context Extension

```dart
extension LocalizedHelper on BuildContext {
  bool get isArabic => /* Check current locale */;
}
```

**Usage in UI:**
```dart
Text(
  context.isArabic ? 'إضافة موقع التوصيل' : 'Add Delivery Location',
)
```

**Text Direction:**
```dart
TextFormField(
  textAlign: context.isArabic ? TextAlign.right : TextAlign.left,
)
```

---

## Platform-Specific Configurations

### Android Permissions (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS Permissions (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to help you select delivery addresses</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to help you select delivery addresses</string>
```

---

## Error Handling Best Practices

### 1. **Permission Errors**
- Always provide fallback to default location
- Show clear error messages to user
- Guide user to settings if permission is permanently denied

### 2. **Network Errors**
- Catch exceptions when calling Nominatim API
- Fallback to showing coordinates if address fetch fails
- Consider implementing retry logic

### 3. **Validation Errors**
- Validate all required fields before saving
- Check coordinate bounds (lat: -90 to 90, lon: -180 to 180)
- Ensure geographic selections are complete

### 4. **Backend Errors**
- Display error messages from API responses
- Don't crash on unexpected responses
- Maintain UI state even after errors

---

## Testing Considerations

### 1. **Permission Scenarios**
- Permission granted on first request
- Permission denied
- Permission permanently denied
- Location services disabled

### 2. **Map Interactions**
- Tap different locations on map
- Zoom in/out
- Pan around
- My location button behavior

### 3. **Form Validation**
- Submit with empty required fields
- Submit with invalid coordinates
- Submit without geographic selections
- Edit mode pre-population

### 4. **Network Scenarios**
- Successful reverse geocoding
- Failed API calls
- Slow network responses
- No internet connection

---

## Additional Notes

### Performance Optimization
- Debounce map tap events to avoid excessive API calls
- Cache addresses for recently selected coordinates
- Use `const` constructors where possible

### Security
- Never hardcode API keys in code
- Use environment variables for sensitive data
- Validate all user inputs server-side

### Scalability
- Consider using Google Maps API or Mapbox for better features and reliability
- Implement pagination for large geographic datasets
- Cache geographic data locally

---

## Summary Checklist

When implementing this feature, ensure you have:

- ✅ Installed all required dependencies
- ✅ Configured platform-specific permissions
- ✅ Implemented LocationCubit with all states
- ✅ Implemented GeographicSelectionCubit
- ✅ Created UI with map and form sections
- ✅ Added location permission flow with fallback
- ✅ Integrated reverse geocoding
- ✅ Added form validation
- ✅ Implemented hierarchical dropdowns
- ✅ Supported both create and edit modes
- ✅ Added proper error handling
- ✅ Styled UI according to design guidelines
- ✅ Implemented multi-language support
- ✅ Tested all permission and network scenarios

---

## Example API Response Structure (for reference)

### Nominatim Reverse Geocoding Response

```json
{
  "place_id": 123456789,
  "licence": "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
  "osm_type": "way",
  "osm_id": 123456789,
  "lat": "12.858493",
  "lon": "45.0030719",
  "display_name": "الشارع التجاري، صنعاء، اليمن",
  "address": {
    "road": "الشارع التجاري",
    "suburb": "الحصبة",
    "city": "صنعاء",
    "state": "أمانة العاصمة",
    "country": "اليمن",
    "country_code": "ye"
  },
  "boundingbox": ["12.8500", "12.8600", "45.0000", "45.0100"]
}
```

---

## Conclusion

This implementation provides a complete, production-ready map-based location picker with:
- User-friendly interactive map interface
- Robust permission handling
- Automatic address resolution
- Hierarchical geographic selection
- Full validation and error handling
- Support for both creating and editing locations
- Clean architecture with BLoC pattern
- Multi-language support

Follow this guide step-by-step to replicate the exact functionality in your Flutter application.
