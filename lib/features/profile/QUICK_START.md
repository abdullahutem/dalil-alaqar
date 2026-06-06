# Profile Feature - Quick Start Guide

## ✅ Feature Complete

The profile feature is fully implemented with both **view** and **edit** functionality integrated into the dashboard!

## What's Been Done

### 1. Backend Integration
- ✅ Added `office/user` endpoint for fetching profile
- ✅ Added `office/profile` endpoint for updating profile
- ✅ Created API data sources for both operations
- ✅ Implemented error handling and network checking

### 2. Clean Architecture Implementation
- ✅ Domain layer with entities, repository interface, and use cases
  - Get profile use case
  - Update profile use case
- ✅ Data layer with models, data sources, and repository implementation
- ✅ Presentation layer with Cubit and states
  - Profile loading/loaded/error states
  - Profile updating/updated/update error states

### 3. UI Integration
- ✅ Updated `DashboardDrawer` to display profile data
- ✅ Shows office logo with cached image loading
- ✅ Displays office name, user name, email, and role
- ✅ Added skeleton loading animation for profile header
- ✅ Added loading and error states with proper fallbacks
- ✅ ProfileCubit provided in DashboardScreen
- ✅ Created full Profile Screen showing complete user/office info
- ✅ Created Edit Profile Screen with form validation
- ✅ Added profile navigation in drawer menu
- ✅ Integrated routes and navigation

## How It Works

### View Profile
When the user navigates to the profile screen:
1. The `ProfileScreen` provides a new `ProfileCubit`
2. The cubit automatically calls `getProfile()` on init
3. The API fetches user and office data
4. The screen displays data in organized cards:
   - User info card (email, phone, WhatsApp)
   - Office info card (name, email, phone, subscription)

### Dashboard Drawer
When the user opens the dashboard:
1. The `DashboardScreen` provides the `ProfileCubit`
2. The `DashboardDrawer` automatically calls `getProfile()` on init
3. The API fetches user and office data
4. The drawer displays the data in a styled header with:
   - Office logo (or default icon)
   - Office name
   - User name  
   - User email
   - User role badge

### Edit Profile
When the user edits their profile:
1. User clicks edit icon in Profile Screen
2. Edit screen opens with pre-filled form
3. User modifies name, phone, and/or WhatsApp
4. User clicks "حفظ التعديلات"
5. Form validates input
6. ProfileCubit calls `updateProfile()` with parameters
7. API updates the profile
8. Success message displays
9. Edit screen auto-closes
10. Profile screen refreshes with updated data

## Testing

To test the feature:

1. **Run the app**:
   ```bash
   flutter run
   ```

2. **Test Profile View**:
   - Login to the app with valid credentials
   - Navigate to Dashboard
   - Open drawer
   - Click "الملف الشخصي"
   - Verify all user and office information displays correctly

3. **Test Drawer Profile Header**:
   - Open the drawer by tapping the menu icon
   - Verify skeleton loading appears briefly
   - Verify profile data loads (logo, name, email, role)

4. **Test Profile Edit**:
   - From Profile Screen, click edit icon
   - Modify your name
   - Modify phone number
   - Modify WhatsApp number (optional)
   - Click "حفظ التعديلات"
   - Verify success message
   - Verify screen closes
   - Verify updated data appears in profile

5. **Test Validation**:
   - Try submitting empty name → Error shown
   - Try name with 2 characters → Error shown
   - Try phone with less than 8 digits → Error shown
   - Submit valid data → Success

6. **Test Loading State**:
   - Click save button
   - Verify button shows loading indicator
   - Verify button is disabled during update

## Current Display in Drawer

```
┌─────────────────────────────┐
│                             │
│    [Office Logo/Icon]       │
│                             │
│   شركة الوفاء العقارية      │
│   أحمد محمد المحدث          │
│   owner-shrk@dalilaqar.iq   │
│   [مالك]                    │
│                             │
└─────────────────────────────┘
```

## API Response Example

The feature expects this response structure:

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 32,
      "name": "أحمد محمد المحدث",
      "email": "owner-shrk-alofaaa-alaakary@dalilaqar.iq",
      "role": "owner",
      "phone_number": "+96478592600565",
      ...
    },
    "office": {
      "id": 11,
      "name": "شركة الوفاء العقارية",
      "logo": "offices/logos/xxx.jpg",
      "email": "office@example.com",
      ...
    }
  }
}
```

## File Changes Summary

### New Files Created (20 files):

**Domain Layer:**
1. `domain/entities/office_entity.dart`
2. `domain/entities/profile_user_entity.dart`
3. `domain/entities/profile_entity.dart`
4. `domain/entities/update_profile_params.dart` ⭐
5. `domain/entities/updated_user_entity.dart` ⭐
6. `domain/repositories/profile_repository.dart`
7. `domain/usecases/get_profile_usecase.dart`
8. `domain/usecases/update_profile_usecase.dart` ⭐

**Data Layer:**
9. `data/models/office_model.dart`
10. `data/models/profile_user_model.dart`
11. `data/models/profile_model.dart`
12. `data/models/updated_user_model.dart` ⭐
13. `data/datasources/profile_remote_data_source.dart`
14. `data/repositories/profile_repository_impl.dart`

**Presentation Layer:**
15. `presentation/cubit/profile_cubit.dart`
16. `presentation/cubit/profile_state.dart`
17. `presentation/widgets/profile_header_skeleton.dart` ⭐
18. `presentation/screens/profile_screen.dart` ⭐
19. `presentation/screens/edit_profile_screen.dart` ⭐

**Documentation:**
20. `PROFILE_FEATURE.md`
21. `QUICK_START.md`
22. `UPDATE_PROFILE_FEATURE.md` ⭐

⭐ = New for update profile feature

### Modified Files (6 files):
1. `core/databases/api/end_points.dart` - Added profile endpoints
2. `core/routes/app_routes.dart` - Added profileScreen route ⭐
3. `core/routes/app_router.dart` - Registered profile route ⭐
4. `features/dashboard/presentation/widgets/dashboard_drawer.dart` - Integrated profile UI & menu ⭐
5. `features/dashboard/presentation/screens/dashboard_screen.dart` - Added ProfileCubit provider
6. All profile domain/data/presentation files updated for edit feature ⭐

## Next Steps (Optional Enhancements)

- [ ] Add profile picture/avatar upload
- [ ] Add password change functionality
- [ ] Add email change with verification
- [ ] Add address field to profile
- [ ] Show last login time
- [ ] Add profile completion percentage
- [ ] Add more detailed phone validation (country code)
- [ ] Add profile activity log
- [ ] Cache profile data locally for offline access
- [ ] Add biometric authentication for sensitive changes

## Support

If you encounter any issues:
1. Check that the API endpoint `office/user` is working correctly
2. Verify that the user is logged in with a valid token
3. Check network connectivity
4. Review the console for any error messages

## Notes

- The feature uses `cached_network_image` for efficient image loading
- Profile data is fetched fresh each time the drawer is opened
- The UI gracefully handles loading and error states
- Fixed deprecated `withOpacity()` usage (now using `withValues()`)
