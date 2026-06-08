# Create Property - Option C Implementation Guide

## Overview
This guide provides step-by-step instructions to implement the full-featured create property screen with map integration.

## Prerequisites
✅ Phase 1 Complete - Backend integration (data/domain layers)
✅ Phase 2 Complete - State management (cubit/states)
⚠️ **IMPORTANT**: Add dependencies from `DEPENDENCIES_NEEDED.md` before proceeding

## Implementation Order

### Part 1: Location Cubit (Map State Management)
**File**: `presentation/cubit/property_location_cubit.dart`
**File**: `presentation/cubit/property_location_state.dart`

**Purpose**: Manages map interactions, location permissions, and reverse geocoding.

**Key Methods**:
- `requestLocationPermission()` - Handle location permissions
- `updateMapPosition(LatLng position)` - Update when user taps map
- `_reverseGeocode(LatLng position)` - Get address from coordinates
- `getCurrentLocation()` - Get device GPS position

**States**:
- `PropertyLocationInitial` - Starting state
- `PropertyLocationLoading` - Getting location/geocoding
- `PropertyLocationUpdated` - New position selected
- `PropertyLocationPermissionDenied` - Permission issues
- `PropertyLocationError` - Errors

### Part 2: Reusable Form Widgets
**File**: `presentation/widgets/property_form_field.dart`

**Purpose**: Styled text field matching app design.

**Features**:
- RTL support
- Validation
- Prefix icons
- Helper text
- Error display

**File**: `presentation/widgets/property_dropdown.dart`

**Purpose**: Styled dropdown matching app design.

**Features**:
- RTL support
- Validation
- Loading state
- Empty state

### Part 3: Location Selection Widget
**File**: `presentation/widgets/property_location_picker.dart`

**Purpose**: Interactive map for selecting property location.

**Features**:
- FlutterMap integration
- OpenStreetMap tiles
- Tap to select marker
- Zoom controls
- My location button
- Address display
- Loading overlay

**Components**:
- Map view (45% of screen)
- Marker at selected position
- Control buttons (zoom +/-, my location)
- Instruction banner
- Address preview

### Part 4: Geographic Selection Widget
**File**: `presentation/widgets/geographic_selection_widget.dart`

**Purpose**: Cascading dropdowns for Governorate → District → Neighborhood.

**Features**:
- Hierarchical selection
- Reset child dropdowns on parent change
- Loading states
- Validation
- Uses existing cubits:
  - `GovernoratesCubit`
  - `DistrictsCubit`  
  - `NeighborhoodsCubit`

### Part 5: Multi-Step Form (Stepper)
**File**: `presentation/screens/create_property_screen.dart`

**Purpose**: Main screen with step-by-step wizard.

**Steps**:

#### Step 1: Basic Information
- Property Type dropdown
- Offer Type dropdown
- Title text field
- Description text field (multiline, 3-5 lines)
- Next button (validates before proceeding)

#### Step 2: Price & Details
- Price text field (numeric keyboard)
- Currency dropdown (default to YER)
- Price Negotiable checkbox
- Next button

#### Step 3: Location Selection
- Interactive map (PropertyLocationPicker widget)
- Address text field (auto-filled from map)
- Geographic selection widget (cascading dropdowns)
- Manual lat/lon entry (optional, for fine-tuning)
- Next button

#### Step 4: Review & Submit
- Summary card showing all entered data
- Map preview (small)
- Edit buttons for each section
- Submit button
- Back button

**Navigation**:
- Stepper with 4 steps
- Progress indicator
- Back button (goes to previous step)
- Next button (validates current step)
- Cancel button (confirmation dialog)

### Part 6: Step Widgets
**File**: `presentation/widgets/basic_info_step.dart`
**File**: `presentation/widgets/price_step.dart`
**File**: `presentation/widgets/location_step.dart`
**File**: `presentation/widgets/review_step.dart`

**Purpose**: Individual step implementations for cleaner code organization.

### Part 7: Integration
**File**: `presentation/screens/office_properties_mobile_layout.dart` (modify)

**Changes**:
- Add FloatingActionButton with `Icons.add`
- Label: "إضافة عقار"
- Navigation to `CreatePropertyScreen`

**On Success**:
- Show success SnackBar
- Navigate to property details screen
- Pass created property ID
- Refresh properties list

## Detailed Implementation Steps

### Step 1: Install Dependencies

1. Add to `pubspec.yaml`:
```yaml
flutter_map: ^7.0.2
latlong2: ^0.9.1
geolocator: ^13.0.2
```

2. Run: `flutter pub get`

3. Configure Android permissions in `AndroidManifest.xml`

4. Configure iOS permissions in `Info.plist`

### Step 2: Create Property Location Cubit

```dart
class PropertyLocationCubit extends Cubit<PropertyLocationState> {
  LatLng currentPosition = const LatLng(15.3694, 44.1910); // Sana'a, Yemen
  String? currentAddress;
  bool hasLocationPermission = false;
  
  PropertyLocationCubit() : super(PropertyLocationInitial());
  
  Future<void> requestLocationPermission() async {
    emit(PropertyLocationLoading());
    
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(PropertyLocationPermissionDenied('خدمة الموقع غير مفعلة'));
      return;
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(PropertyLocationPermissionDenied('تم رفض إذن الموقع'));
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      emit(PropertyLocationPermissionDenied('تم رفض إذن الموقع بشكل دائم'));
      return;
    }
    
    try {
      Position position = await Geolocator.getCurrentPosition();
      currentPosition = LatLng(position.latitude, position.longitude);
      hasLocationPermission = true;
      await _reverseGeocode(currentPosition);
      emit(PropertyLocationUpdated(currentPosition, currentAddress));
    } catch (e) {
      emit(PropertyLocationError('فشل الحصول على الموقع'));
    }
  }
  
  Future<void> updateMapPosition(LatLng position) async {
    currentPosition = position;
    emit(PropertyLocationLoading());
    await _reverseGeocode(position);
    emit(PropertyLocationUpdated(position, currentAddress));
  }
  
  Future<void> _reverseGeocode(LatLng position) async {
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
          'accept-language': 'ar',
        },
        options: Options(
          headers: {'User-Agent': 'DalilAlaqar/1.0'},
        ),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        currentAddress = response.data['display_name'] ?? 
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      }
    } catch (e) {
      currentAddress = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    }
  }
}
```

### Step 3: Create Flutter Map Widget

```dart
FlutterMap(
  mapController: _mapController,
  options: MapOptions(
    initialCenter: locationCubit.currentPosition,
    initialZoom: 15.0,
    minZoom: 5.0,
    maxZoom: 18.0,
    onTap: (tapPosition, point) {
      locationCubit.updateMapPosition(point);
    },
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.dalilalaqar.app',
    ),
    MarkerLayer(
      markers: [
        Marker(
          point: locationCubit.currentPosition,
          width: 50,
          height: 50,
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        ),
      ],
    ),
  ],
)
```

### Step 4: Create Stepper Logic

```dart
class CreatePropertyScreen extends StatefulWidget {
  @override
  State<CreatePropertyScreen> createState() => _CreatePropertyScreenState();
}

class _CreatePropertyScreenState extends State<CreatePropertyScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Selected values
  int? _selectedPropertyType;
  int? _selectedOfferType;
  int? _selectedCurrency = 1; // Default YER
  bool _priceNegotiable = false;
  int? _selectedGovernorate;
  int? _selectedDistrict;
  int? _selectedNeighborhood;
  
  List<Step> _buildSteps() {
    return [
      Step(
        title: Text('المعلومات الأساسية'),
        content: BasicInfoStep(...),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('السعر'),
        content: PriceStep(...),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('الموقع'),
        content: LocationStep(...),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('المراجعة'),
        content: ReviewStep(...),
        isActive: _currentStep >= 3,
      ),
    ];
  }
  
  void _onStepContinue() {
    if (_validateCurrentStep()) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
      } else {
        _submitProperty();
      }
    }
  }
  
  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
  
  bool _validateCurrentStep() {
    // Implement validation per step
    return true;
  }
  
  void _submitProperty() {
    final locationCubit = context.read<PropertyLocationCubit>();
    
    final property = CreatePropertyEntity(
      propertyTypeId: _selectedPropertyType!,
      offerTypeId: _selectedOfferType!,
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      priceNegotiable: _priceNegotiable,
      governorateId: _selectedGovernorate!,
      districtId: _selectedDistrict!,
      neighborhoodId: _selectedNeighborhood!,
      address: _addressController.text,
      latitude: locationCubit.currentPosition.latitude,
      longitude: locationCubit.currentPosition.longitude,
      currencyId: _selectedCurrency!,
      status: 'available',
    );
    
    context.read<CreatePropertyCubit>().createProperty(property);
  }
}
```

### Step 5: Add FAB to Properties List

```dart
// In office_properties_mobile_layout.dart
FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePropertyScreen(),
      ),
    );
  },
  child: Icon(Icons.add),
  tooltip: 'إضافة عقار',
)
```

## Error Handling

### Location Permission Denied
```dart
if (state is PropertyLocationPermissionDenied) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('إذن الموقع'),
      content: Text(state.message),
      actions: [
        TextButton(
          onPressed: () {
            Geolocator.openAppSettings();
          },
          child: Text('فتح الإعدادات'),
        ),
      ],
    ),
  );
}
```

### Validation Errors
```dart
if (state is CreatePropertyValidationError) {
  // Show errors for each field
  state.errors.forEach((field, error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  });
}
```

### Network Errors
```dart
if (state is CreatePropertyError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(state.message),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'إعادة المحاولة',
        onPressed: () => _submitProperty(),
      ),
    ),
  );
}
```

## Testing Checklist

- [ ] Location permission granted
- [ ] Location permission denied
- [ ] Location service disabled
- [ ] Map tap updates position
- [ ] Reverse geocoding works
- [ ] Address auto-fills
- [ ] All form validations
- [ ] Cascading dropdowns
- [ ] Step navigation
- [ ] Form submission
- [ ] Success navigation
- [ ] Error handling
- [ ] Network offline
- [ ] Loading states

## Performance Considerations

1. **Debounce Map Taps**: Wait 500ms before reverse geocoding
2. **Cache Addresses**: Store recent geocoding results
3. **Optimize Map Tiles**: Use appropriate zoom levels
4. **Lazy Load Dropdowns**: Load districts/neighborhoods on demand

## UI/UX Best Practices

1. **Loading Indicators**: Show during geocoding and submission
2. **Disabled States**: Disable next button until validation passes
3. **Progress Indicator**: Show current step clearly
4. **Confirmation Dialog**: Ask before canceling with data
5. **Success Feedback**: Clear message + auto-navigation
6. **Error Feedback**: Clear, actionable error messages

## Next Steps After Implementation

1. Test thoroughly on both Android and iOS
2. Handle edge cases (no internet, GPS off, etc.)
3. Add analytics tracking
4. Consider adding image upload in creation flow
5. Add draft save functionality
6. Performance testing with real devices

## Estimated Timeline

- Location Cubit: 2 hours
- Map Integration: 3 hours  
- Form Widgets: 2 hours
- Stepper Implementation: 4 hours
- Integration & Testing: 4 hours
- **Total: 15 hours**

## Support & References

- Flutter Map Docs: https://docs.fleaflet.dev/
- Geolocator Docs: https://pub.dev/packages/geolocator
- OSM Nominatim API: https://nominatim.org/release-docs/latest/api/Reverse/
- Map Implementation Guide: `lib/map_location_implementation_prompt.md`
