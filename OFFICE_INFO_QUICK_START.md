# Office Info Features - Quick Start Guide

## 🚀 What's New

Three powerful features for managing office information:

1. **View Office Info** - Display all office details
2. **Update Office Info** - Edit office information
3. **Upload Office Logo** - Add or change office logo

## 📦 Installation

The `image_picker` package has been added. If you need to reinstall dependencies:

```bash
flutter pub get
```

## 🎯 How to Use

### Viewing Office Info
Navigate to the Office Info screen from your app's main navigation.

### Updating Office Info
1. Scroll to the bottom of the Office Info screen
2. Tap **"تعديل معلومات المكتب"** button
3. Edit any fields you want to update
4. Tap **"حفظ التغييرات"** to save

### Uploading Office Logo
1. On the Office Info screen, tap the **camera icon** on the logo
2. Choose **"التقاط صورة"** (camera) or **"اختيار من المعرض"** (gallery)
3. Select or capture an image
4. Tap **"رفع الشعار"** to upload

## 📱 Platform Setup

### iOS Setup
Add these permissions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>نحتاج إلى الوصول إلى الكاميرا لالتقاط صورة الشعار</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>نحتاج إلى الوصول إلى المعرض لاختيار صورة الشعار</string>
```

### Android Setup
No additional setup required - permissions are handled automatically.

## 🔧 API Configuration

All endpoints are already configured in `lib/core/databases/api/end_points.dart`:

- **Get**: `office/office`
- **Update**: `office/office` (PUT)
- **Upload Logo**: `office/office/logo` (POST)

## 🎨 Features Highlights

### Update Office Info
- ✅ Pre-filled form with current data
- ✅ Form validation
- ✅ Real-time error feedback
- ✅ Loading states
- ✅ Auto-refresh after update

### Upload Office Logo
- ✅ Camera and gallery support
- ✅ Image preview
- ✅ Automatic image optimization
- ✅ Loading states
- ✅ Auto-refresh after upload

## 🐛 Troubleshooting

### Issue: Camera/Gallery not opening on iOS
**Solution**: Make sure you've added the required permissions to Info.plist

### Issue: Image upload fails
**Solution**: Check:
- Network connection
- Authentication token is valid
- Image file is not corrupted
- Server is accessible

### Issue: Form validation errors
**Solution**: 
- Phone and Email are required fields
- Email must contain '@' symbol
- Check all required fields are filled

### Issue: Logo not displaying after upload
**Solution**:
- Wait for the screen to refresh
- Pull down to manually refresh
- Check network connection

## 📚 Documentation

For detailed documentation, see:
- `UPDATE_OFFICE_INFO_FEATURE.md` - Update feature details
- `UPLOAD_OFFICE_LOGO_FEATURE.md` - Upload feature details
- `OFFICE_INFO_FEATURES_SUMMARY.md` - Complete overview

## 🧪 Testing

### Quick Test Checklist
- [ ] View office info screen loads correctly
- [ ] Update button opens update form
- [ ] Form shows current data
- [ ] Can save updates successfully
- [ ] Camera icon opens upload screen
- [ ] Can select image from gallery
- [ ] Can capture image with camera
- [ ] Logo uploads successfully
- [ ] Screen refreshes after changes

## 💡 Tips

1. **Best Logo Quality**: Use square images with transparent backgrounds
2. **Fast Updates**: Only modify fields you want to change
3. **Image Size**: Images are automatically optimized to 1024x1024
4. **Network**: Features work best with stable internet connection

## 🔐 Security

- All endpoints require authentication
- Tokens are handled automatically
- Images are validated on server
- HTTPS is used for all requests

## 📞 Support

If you encounter any issues:
1. Check the troubleshooting section above
2. Review the detailed documentation files
3. Check server logs for API errors
4. Verify authentication tokens are valid

---

**Ready to use!** 🎉

Navigate to the Office Info screen and start managing your office information.
