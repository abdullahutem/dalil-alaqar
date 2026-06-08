# Required Dependencies for Create Property Feature

## Add to pubspec.yaml

```yaml
dependencies:
  # ... existing dependencies ...
  
  # Map & Location (for Create Property feature)
  flutter_map: ^7.0.2      # For displaying interactive maps
  latlong2: ^0.9.1         # For handling latitude/longitude coordinates
  geolocator: ^13.0.2      # For device location permissions and GPS access
```

## Installation Command

Run this command after adding to pubspec.yaml:
```bash
flutter pub get
```

## Platform-Specific Configuration

### Android (`android/app/src/main/AndroidManifest.xml`)

Add these permissions before the `<application>` tag:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (`ios/Runner/Info.plist`)

Add these keys:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>نحتاج إلى موقعك لمساعدتك في تحديد موقع العقار</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>نحتاج إلى موقعك لمساعدتك في تحديد موقع العقار</string>
```

## Verification

After installation, verify the packages are installed:
```bash
flutter pub deps | grep -E "flutter_map|latlong2|geolocator"
```

## Notes

- These dependencies are only used for the Create Property feature
- `flutter_map` uses OpenStreetMap tiles (free and open source)
- `geolocator` handles location permissions across platforms
- `latlong2` is a lightweight coordinate handling library
