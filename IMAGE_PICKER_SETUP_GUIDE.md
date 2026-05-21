# Image Picker Setup Guide

## Issue: MissingPluginException on iOS

If you encounter this error:
```
MissingPluginException(No implementation found for method pickImage on channel plugins.flutter.io/image_picker)
```

This means the native iOS plugin wasn't properly registered. Follow these steps:

## Solution Steps

### 1. Clean the Project
```bash
flutter clean
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Add iOS Permissions
The permissions have been added to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>نحتاج إلى الوصول إلى الكاميرا لالتقاط صورة الشعار</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>نحتاج إلى الوصول إلى المعرض لاختيار صورة الشعار</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>نحتاج إلى الوصول إلى المعرض لحفظ الصور</string>
```

### 4. Install iOS Pods
```bash
cd ios
pod install
cd ..
```

### 5. Rebuild the App
Stop the current app and rebuild:

**For iOS Simulator:**
```bash
flutter run
```

**For iOS Device:**
```bash
flutter run -d <device-id>
```

## Verification

After rebuilding, test the image picker:
1. Navigate to Office Info screen
2. Tap the camera icon on the logo
3. Try selecting an image from gallery
4. The image picker should now work without errors

## iOS Simulator Limitations

⚠️ **Important**: iOS Simulator has limited camera support:
- **Camera**: Not available on simulator (will show error)
- **Photo Library**: Works on simulator

For full testing including camera, use a **real iOS device**.

## Alternative: Test on Real Device

To test on a real iOS device:

1. Connect your iPhone/iPad via USB
2. Trust the computer on your device
3. Run: `flutter devices` to see available devices
4. Run: `flutter run -d <your-device-id>`

## Common Issues

### Issue: "No devices found"
**Solution**: 
- Make sure your device is connected
- Trust the computer on your device
- Enable Developer Mode on iOS 16+ devices

### Issue: "Code signing required"
**Solution**:
- Open `ios/Runner.xcworkspace` in Xcode
- Select your development team
- Configure signing

### Issue: Permission dialogs not showing
**Solution**:
- Uninstall the app completely
- Rebuild and reinstall
- Permissions will be requested on first use

### Issue: Pods installation fails
**Solution**:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

## Testing Checklist

- [ ] App builds successfully
- [ ] No MissingPluginException errors
- [ ] Photo library picker opens (simulator)
- [ ] Camera opens (real device only)
- [ ] Permission dialogs appear
- [ ] Image selection works
- [ ] Image upload completes

## Platform-Specific Notes

### iOS Simulator
✅ Photo Library: Works
❌ Camera: Not available

### iOS Real Device
✅ Photo Library: Works
✅ Camera: Works

### Android Emulator
✅ Photo Library: Works
✅ Camera: Works (with virtual camera)

### Android Real Device
✅ Photo Library: Works
✅ Camera: Works

## Additional Configuration (Optional)

### Minimum iOS Version
The Podfile is configured for iOS 13.0+:
```ruby
platform :ios, '13.0'
```

### Camera Quality Settings
In the upload screen, images are optimized:
```dart
maxWidth: 1024,
maxHeight: 1024,
imageQuality: 85,
```

You can adjust these values in:
`lib/features/office_info/presentation/screens/upload_office_logo_screen.dart`

## Debugging

### Enable Verbose Logging
```bash
flutter run -v
```

### Check Plugin Registration
Look for this in the logs:
```
Registered plugin: image_picker_ios
```

### Check Permissions
After running the app, check if permissions were added:
```bash
cat ios/Runner/Info.plist | grep -A 1 "NSCamera"
```

## Support

If issues persist:
1. Check Flutter version: `flutter --version`
2. Check iOS deployment target in Xcode
3. Verify Podfile.lock includes image_picker_ios
4. Try on a real device instead of simulator
5. Check console logs for detailed error messages

## Quick Fix Commands

Run these commands in sequence if you encounter issues:

```bash
# Clean everything
flutter clean
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks

# Reinstall
flutter pub get
cd ios
pod install
cd ..

# Rebuild
flutter run
```

---

**Status**: ✅ Setup Complete
**Last Updated**: May 21, 2026
