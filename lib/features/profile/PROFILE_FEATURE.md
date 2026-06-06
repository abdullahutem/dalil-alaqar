# Profile Feature Documentation

## Overview
This feature fetches and displays the current user's profile information in the dashboard drawer. It retrieves user and office data from the backend API and displays it with the office logo, user name, email, and role.

## API Endpoint
- **Endpoint**: `office/user`
- **Method**: GET
- **Response Structure**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 32,
      "name": "أحمد محمد المحدث",
      "email": "owner-shrk-alofaaa-alaakary@dalilaqar.iq",
      "user_type": "office_owner",
      "role": "owner",
      "office_id": 11,
      "phone_number": "+96478592600565",
      "whatsapp_number": null,
      "address": null,
      "is_active": true,
      "last_login_at": "2026-05-21T13:38:37.000000Z",
      "avatar": null,
      "locale": "ar",
      "office": { ... }
    },
    "office": {
      "id": 11,
      "name": "شركة الوفاء العقارية",
      "owner_name": "حيدر علي الحسيني",
      "slug": "shrk-alofaaa-alaakary",
      "logo": "offices/logos/3xpuxoGLj1NRhAQmqUyoZe9GPvgjLrV6U1El22L3.jpg",
      "email": "newemailaaa@office.com",
      "phone": "777111222",
      "mobile_phone": "+96475342611777",
      "whatsapp_number": "777111222",
      ...
    }
  }
}
```

## Architecture

### Domain Layer
- **Entities**:
  - `ProfileEntity`: Main profile entity containing user and office data
  - `ProfileUserEntity`: User information entity
  - `OfficeEntity`: Office information entity

- **Repository Interface**: `ProfileRepository`
- **Use Case**: `GetProfileUseCase`

### Data Layer
- **Models**:
  - `ProfileModel`: Extends `ProfileEntity` with JSON serialization
  - `ProfileUserModel`: Extends `ProfileUserEntity` with JSON serialization
  - `OfficeModel`: Extends `OfficeEntity` with JSON serialization

- **Data Source**: `ProfileRemoteDataSource`
- **Repository Implementation**: `ProfileRepositoryImpl`

### Presentation Layer
- **Cubit**: `ProfileCubit` - Manages profile state
- **States**:
  - `ProfileInitial`: Initial state
  - `ProfileLoading`: Loading profile data
  - `ProfileLoaded`: Profile data loaded successfully
  - `ProfileError`: Error loading profile
- **Widgets**:
  - `ProfileHeaderSkeleton`: Animated skeleton loading for the drawer header

## UI Integration

The profile data is displayed in the **Dashboard Drawer**:

### Features Displayed:
1. **Office Logo**: Circular avatar showing the office logo (or default icon if not available)
2. **Office Name**: Displayed prominently in bold white text
3. **User Name**: Displayed below the office name
4. **User Email**: Displayed below the user name
5. **User Role Badge**: Small badge showing the user's role (e.g., "مالك" for owner)

### Loading State (Skeleton)
While loading, the drawer shows an animated skeleton with:
- Pulsing circular avatar placeholder
- Animated shimmer bars for office name
- Animated shimmer bars for user name
- Animated shimmer bars for email
- Animated shimmer bar for role badge

The skeleton uses a smooth fade animation (1.5s duration) to create a professional loading experience.

### Error/Default State
If loading fails, the drawer shows:
- Default person icon
- Generic "مكتب العقارات" text
- Generic email

## Usage

The `ProfileCubit` is automatically provided in the `DashboardScreen` using `MultiBlocProvider`:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => DashboardCubit.create()..getDashboardStats(),
    ),
    BlocProvider(
      create: (context) => ProfileCubit.create(),
    ),
  ],
  child: const DashboardResponsive(),
)
```

The `DashboardDrawer` listens to `ProfileCubit` state and automatically loads profile data when initialized:

```dart
@override
void initState() {
  super.initState();
  context.read<ProfileCubit>().getProfile();
}
```

## File Structure
```
lib/features/profile/
├── domain/
│   ├── entities/
│   │   ├── office_entity.dart
│   │   ├── profile_user_entity.dart
│   │   └── profile_entity.dart
│   ├── repositories/
│   │   └── profile_repository.dart
│   └── usecases/
│       └── get_profile_usecase.dart
├── data/
│   ├── models/
│   │   ├── office_model.dart
│   │   ├── profile_user_model.dart
│   │   └── profile_model.dart
│   ├── datasources/
│   │   └── profile_remote_data_source.dart
│   └── repositories/
│       └── profile_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── profile_cubit.dart
    │   └── profile_state.dart
    └── widgets/
        └── profile_header_skeleton.dart
```

## Dependencies
- `flutter_bloc`: State management
- `dartz`: Functional programming (Either type)
- `dio`: HTTP client
- `cached_network_image`: Image caching and loading
- `data_connection_checker_tv`: Network connectivity checking

## Future Enhancements
- Add pull-to-refresh functionality in the drawer
- Add profile editing capability
- Show subscription information in the drawer
- Add profile image upload for users
- Cache profile data locally
