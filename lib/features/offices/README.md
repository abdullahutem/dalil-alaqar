# Offices Feature

## Overview
The Offices feature displays a list of real estate offices fetched from the `public/offices` API endpoint. It follows the clean architecture pattern used throughout the `dalil_alaqar` project.

## Directory Structure

```
lib/features/offices/
├── domain/
│   ├── entities/
│   │   ├── office_entity.dart          # Core office entity + governorate/district
│   │   └── offices_response_entity.dart # Response wrapper + meta entity
│   ├── repositories/
│   │   └── offices_repository.dart     # Abstract repository interface
│   └── usecases/
│       └── get_offices_usecase.dart    # Use case for fetching offices
├── data/
│   ├── models/
│   │   ├── office_model.dart           # Office model with fromJson/toJson
│   │   └── offices_response_model.dart # Response model with meta
│   ├── datasources/
│   │   └── offices_remote_data_source.dart # API consumer (Dio)
│   └── repositories/
│       └── offices_repository_impl.dart    # Concrete repository implementation
├── presentation/
│   ├── cubit/
│   │   ├── offices_cubit.dart          # Business logic + factory create()
│   │   └── offices_state.dart          # States: Initial, Loading, Success, Error, LoadMoreError
│   ├── screens/
│   │   ├── offices_screen.dart         # Main screen with LayoutBuilder
│   │   ├── offices_mobile_layout.dart  # Mobile list view (< 600px)
│   │   └── offices_tablet_layout.dart  # Tablet 2-column grid (≥ 600px)
│   └── widgets/
│       ├── office_card.dart            # Full card for list/grid display
│       ├── office_card_compact.dart    # Compact 280px card for horizontal scroll
│       └── offices_section.dart        # Home screen section with horizontal list
└── README.md
```

## API Endpoint

- **URL**: `public/offices`
- **Method**: GET
- **Query Parameters**:
  - `page` (int): Page number, default 1
  - `per_page` (int): Items per page, default 20

## Key Fields in Office Entity

| Field | Type | Nullable | Description |
|---|---|---|---|
| id | int | No | Unique identifier |
| name | String | No | Office name (Arabic) |
| owner_name | String | Yes | Owner's full name |
| slug | String | No | URL-friendly identifier |
| logo | String | Yes | Logo image URL |
| phone | String | Yes | Main phone number |
| mobile_phone | String | Yes | Mobile number |
| whatsapp_number | String | Yes | WhatsApp number |
| address | String | Yes | Full address |
| subscription_type | String | Yes | Subscription tier |
| is_verified | bool | No | Verification status |
| rating | double | Yes | Average rating (0-5) |
| total_ratings | int | Yes | Number of ratings |
| total_properties | int | Yes | Number of listed properties |
| total_views | int | Yes | Total view count |
| governorate | GovernorateEntity | Yes | Related governorate |
| district | DistrictEntity | Yes | Related district |

## State Management

The `OfficesCubit` manages the following states:

- `OfficesInitial` — before any data is fetched
- `OfficesLoading` — initial data fetch in progress
- `OfficesSuccess` — data fetched successfully, includes pagination info
- `OfficesError` — initial fetch failed
- `OfficesLoadMoreError` — load more failed, existing data preserved

## Usage

### Navigate to Offices Screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const OfficesScreen()),
);
```

### Add to Home Screen
```dart
// In home_mobile_layout.dart or home_tablet_layout.dart:
import 'package:your_app/features/offices/presentation/widgets/offices_section.dart';

// Inside your home screen's Column/ListView:
const OfficesSection(),
```

### Standalone Cubit
```dart
BlocProvider(
  create: (_) => OfficesCubit.create()..getOffices(),
  child: const OfficesScreen(),
);
```

## Core Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.x.x
  dartz: ^0.10.x
  dio: ^5.x.x
  equatable: ^2.x.x
  cached_network_image: ^3.x.x
  internet_connection_checker: ^1.x.x
```

## Endpoint Registration

Add to `lib/core/databases/api/end_points.dart`:

```dart
static const String offices = 'public/offices';
```

## Dark/Light Mode

All colors are sourced from `Theme.of(context)`:
- Card backgrounds: `theme.cardColor`
- Text: `theme.textTheme.bodyXxx?.color`
- Primary accent: `theme.colorScheme.primary`
- Shadows use low opacity (`0.08` light, `0.3` dark)

## Pagination

- Default page size: 20 items
- Auto-loads next page when scrolling within 200px (mobile) or 300px (tablet) of the bottom
- Pull-to-refresh resets to page 1
- `hasReachedMax` flag prevents unnecessary API calls

## Subscription Badge Colors

| Type | Color |
|---|---|
| الباقة الذهبية | Gold (#FFD700) |
| باقة VIP | Purple (#9C27B0) |
| الباقة الفضية | Grey |
| Other | Primary theme color |
