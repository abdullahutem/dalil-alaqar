# Promotions Feature

## Overview
The Promotions feature displays active promotional offers fetched from `public/promotions`. It supports three discount types — percentage, fixed amount, and free feature — each with distinct visual treatment, usage progress indicators, and expiry dates.

## Directory Structure

```
lib/features/promotions/
├── domain/
│   ├── entities/
│   │   ├── promotion_entity.dart           # Core entity with computed helpers
│   │   └── promotions_response_entity.dart # Response wrapper
│   ├── repositories/
│   │   └── promotions_repository.dart      # Abstract repository
│   └── usecases/
│       └── get_promotions_usecase.dart     # Fetch use case
├── data/
│   ├── models/
│   │   ├── promotion_model.dart            # fromJson/toJson; handles nullable discount_value
│   │   └── promotions_response_model.dart  # Response model
│   ├── datasources/
│   │   └── promotions_remote_data_source.dart
│   └── repositories/
│       └── promotions_repository_impl.dart
├── presentation/
│   ├── cubit/
│   │   ├── promotions_cubit.dart           # create() factory + getPromotions/refresh
│   │   └── promotions_state.dart           # Initial, Loading, Success, Error
│   ├── screens/
│   │   ├── promotions_screen.dart          # LayoutBuilder wrapper
│   │   ├── promotions_mobile_layout.dart   # Vertical list (< 600px)
│   │   └── promotions_tablet_layout.dart   # 2-column grid (≥ 600px)
│   └── widgets/
│       ├── promotion_card.dart             # Full card with all details
│       ├── promotion_card_compact.dart     # 240px compact for home scroll
│       └── promotions_section.dart         # Home screen section widget
└── README.md
```

## API Endpoint

- **URL**: `public/promotions`
- **Method**: GET
- **No pagination** (all promotions returned in a single response)

## Promotion Types

| type | Color | Icon | Discount Display |
|---|---|---|---|
| `percentage` | Blue `#2196F3` | `Icons.percent` | `خصم X%` |
| `fixed_amount` | Green `#4CAF50` | `Icons.attach_money` | `خصم X,000 د.ع` |
| `free_feature` | Purple `#9C27B0` | `Icons.card_giftcard` | `مجاناً` |

## Entity Fields

| Field | Type | Nullable | Notes |
|---|---|---|---|
| id | int | No | |
| title | String | No | Arabic promotion title |
| description | String | Yes | |
| image | String | Yes | URL |
| type | String | No | `percentage` / `fixed_amount` / `free_feature` |
| discountValue | double | Yes | Null for `free_feature` type |
| officeId | int | Yes | Links to an office |
| propertyId | int | Yes | Links to a specific property |
| planId | int | Yes | Links to a subscription plan |
| startDate | String | Yes | ISO 8601 |
| endDate | String | Yes | ISO 8601 |
| terms | String | Yes | Displayed in italic info box |
| maxUsage | int | Yes | Null = unlimited |
| usageCount | int | No | Always present |
| isActive | bool | No | |
| status | String | Yes | `active` etc. |

### Computed properties on `PromotionEntity`
- `isPercentage` / `isFixedAmount` / `isFreeFeature` — type convenience getters
- `remainingUsage` — `maxUsage - usageCount` (null if maxUsage is null)
- `usagePercentage` — 0.0–1.0 for progress bar

## Card Features

### `PromotionCard` (full)
- Color-coded top accent bar per type
- Logo/icon placeholder with type-specific icon
- Type badge label (خصم نسبي / خصم ثابت / ميزة مجانية)
- Discount badge with formatted value
- Description (max 2 lines)
- Footer: end date + usage count
- Usage progress bar (only when `maxUsage != null`)
- Terms box in italic (only when `terms != null`)

### `PromotionCardCompact` (240px, home screen)
- Color accent top bar
- Icon + type label
- Title (2 lines)
- Discount chip
- End date

## Usage

### Navigate to Promotions Screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const PromotionsScreen()),
);
```

### Add to Home Screen
```dart
// In home_mobile_layout.dart or home_tablet_layout.dart:
import 'package:your_app/features/promotions/presentation/widgets/promotions_section.dart';

const PromotionsSection(),
```

## Endpoint Registration

Add to `lib/core/databases/api/end_points.dart`:

```dart
static const String promotions = 'public/promotions';
```

## State Management

States: `PromotionsInitial` → `PromotionsLoading` → `PromotionsSuccess` | `PromotionsError`

No `LoadMoreError` state — this endpoint returns all items at once without pagination.

## Dark/Light Mode

- Card backgrounds: `theme.cardColor`
- Text: `theme.textTheme.*?.color`
- Type colors are constant (blue/green/purple) — high contrast in both modes
- Progress bars: type color on `color.withOpacity(0.15)` background
- Terms box: `Colors.grey.withOpacity(0.08)` — subtle in both themes
