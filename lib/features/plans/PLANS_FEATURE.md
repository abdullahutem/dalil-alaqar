# Plans Feature Documentation

## Overview
This feature displays available subscription plans/packages with their pricing, features, and limits. Users can view all available plans and select the one that best fits their needs.

## API Endpoint
- **Endpoint**: `office/plans`
- **Method**: GET
- **Response**:
```json
{
  "success": true,
  "message": "تم جلب الباقات بنجاح",
  "data": [
    {
      "id": 4,
      "name": "الباقة الماسية",
      "slug": "diamond",
      "description": "باقة مميزة للشركات العقارية الكبرى",
      "prices": {
        "monthly": "400000.00",
        "quarterly": "1080000.00",
        "semi_annual": "2000000.00",
        "annual": "3840000.00"
      },
      "limits": {
        "max_properties": 0,
        "max_employees": 25,
        "is_unlimited_properties": false,
        "is_unlimited_employees": false
      },
      "features": [
        "عقارات غير محدودة",
        "25 موظف",
        "مدير حساب مخصص",
        "تقارير مخصصة",
        "أولوية قصوى في البحث",
        "صفحة مخصصة للمكتب",
        "إعلانات مجانية"
      ],
      "priority_level": 10,
      "trial_days": 30,
      "has_trial": true
    }
  ]
}
```

## Architecture

### Domain Layer

#### Entities
- **PlanEntity**: Main plan entity
  - `id`: Plan ID
  - `name`: Plan name (e.g., "الباقة الماسية")
  - `slug`: Plan identifier (e.g., "diamond")
  - `description`: Plan description
  - `prices`: Pricing information (PlanPricesEntity)
  - `limits`: Usage limits (PlanLimitsEntity)
  - `features`: List of features
  - `priorityLevel`: Plan priority/ranking
  - `trialDays`: Trial period duration
  - `hasTrial`: Whether trial is available

- **PlanPricesEntity**: Pricing structure
  - `monthly`: Monthly price
  - `quarterly`: Quarterly price (3 months)
  - `semiAnnual`: Semi-annual price (6 months)
  - `annual`: Annual price (12 months)

- **PlanLimitsEntity**: Usage limits
  - `maxProperties`: Maximum properties allowed
  - `maxEmployees`: Maximum employees allowed
  - `isUnlimitedProperties`: Unlimited properties flag
  - `isUnlimitedEmployees`: Unlimited employees flag

#### Repository Interface
- `PlansRepository.getPlans()`: Abstract method for fetching plans

#### Use Case
- **GetPlansUseCase**: Handles business logic for fetching plans

### Data Layer

#### Models
- **PlanModel**: Extends `PlanEntity` with JSON serialization
- **PlanPricesModel**: Extends `PlanPricesEntity` with JSON serialization
- **PlanLimitsModel**: Extends `PlanLimitsEntity` with JSON serialization

#### Data Source
- **PlansRemoteDataSource.getPlans()**: API communication
  - Makes GET request to `office/plans`
  - Parses response into list of PlanModel
  - Throws exceptions on failure

#### Repository Implementation
- **PlansRepositoryImpl.getPlans()**: Implementation
  - Checks network connectivity
  - Calls remote data source
  - Handles errors and returns Either type

### Presentation Layer

#### Cubit States
- **PlansInitial**: Initial state
- **PlansLoading**: Loading plans
- **PlansLoaded**: Plans loaded successfully
  - Contains `List<PlanEntity>`
- **PlansError**: Loading failed
  - Contains error message

#### PlansCubit Methods
- **getPlans()**: Fetches all available plans
  - Emits `PlansLoading` state
  - Calls use case
  - Emits `PlansLoaded` or `PlansError`

## UI Components

### Plans Screen (`plans_screen.dart`)
Main screen displaying all available subscription plans:

**Features:**
- Grid/List view of all plans
- Color-coded plan cards by tier
- Pull-to-refresh functionality
- Loading state with skeleton
- Error state with retry button
- Empty state when no plans available

**Plan Display:**
- Plan icon and name
- Description
- Price section with all billing periods
- Limits (properties & employees)
- Features list with checkmarks
- Trial badge if available
- Selection button

### Plan Card Widget (`plan_card.dart`)
Individual plan card component:

**Visual Features:**
- Color-coded by plan tier:
  - Diamond: Indigo (#6366F1)
  - Gold: Amber (#F59E0B)
  - Silver: Purple (#8B5CF6)
  - Basic: Blue (#3B82F6)
- Icon based on plan tier
- Gradient background for current plan
- Border highlight for current plan

**Information Displayed:**
1. **Header**:
   - Plan icon in colored container
   - Plan name in plan color
   - "Current Plan" badge if applicable

2. **Description**:
   - Plan description text

3. **Pricing Section**:
   - Large monthly price display
   - All billing periods listed:
     - Quarterly
     - Semi-annual
     - Annual

4. **Limits Section**:
   - Properties limit or "unlimited"
   - Employees limit or "unlimited"

5. **Features List**:
   - Checkmark icons
   - Feature descriptions

6. **Trial Badge** (if available):
   - Star icon
   - Trial duration

7. **Action Button**:
   - "اختيار هذه الباقة" for other plans
   - "باقتك الحالية" for current plan (disabled)

### Plan Card Skeleton (`plan_card_skeleton.dart`)
Animated loading skeleton:
- Pulsing animation (1.5s duration)
- Mimics plan card structure
- Shimmer effect on all elements

## User Flow

1. **View Plans**:
   ```
   Dashboard → Open Drawer → Click "الباقات والاشتراكات" → Plans Screen
   ```

2. **Select Plan**:
   ```
   Plans Screen → Click "اختيار هذه الباقة"
   → Confirmation Dialog → Confirm
   → Subscription Process (TODO)
   ```

3. **Refresh Plans**:
   ```
   Plans Screen → Pull Down → Refresh
   ```

## Integration Points

### Dashboard Drawer
- Menu item: "الباقات والاشتراكات"
- Icon: `Icons.card_membership`
- Links to Plans Screen

### Routes
- Added `AppRoutes.plansScreen = '/plans_screen'`
- Registered in `AppRouter.onGenerateRoute()`

## Plan Tiers

### Diamond (الباقة الماسية)
- **Color**: Indigo
- **Icon**: Diamond
- **Priority**: 10 (Highest)
- **Trial**: 30 days
- **Target**: Large companies

### Gold (الباقة الذهبية)
- **Color**: Amber
- **Icon**: Premium badge
- **Priority**: 7
- **Trial**: 14 days
- **Target**: Large offices

### Silver (الباقة الفضية)
- **Color**: Purple
- **Icon**: Stars
- **Priority**: 3
- **Trial**: 14 days
- **Target**: Medium offices

### Basic (الباقة الأساسية)
- **Color**: Blue
- **Icon**: Bookmark
- **Priority**: 1
- **Trial**: 7 days
- **Target**: Small/beginner offices

## Price Formatting

Prices are displayed with:
- Comma separators for thousands
- No decimal places if `.00`
- "دينار" suffix
- Billing period label (شهرياً, ربع سنوي, etc.)

## Current Plan Detection

Currently uses hardcoded logic:
```dart
final isCurrentPlan = plan.slug == 'basic';
```

**TODO**: Integrate with actual user subscription data

## Features Display

Features are shown as a list with:
- Check circle icon in plan color
- Feature text
- 12px bottom spacing between items

## Subscription Flow (TODO)

When user selects a plan:
1. Confirmation dialog appears
2. Shows plan name
3. Shows trial period if available
4. User confirms
5. **TODO**: Implement actual subscription logic
6. **TODO**: Payment integration
7. **TODO**: Subscription activation

## File Structure

```
lib/features/plans/
├── domain/
│   ├── entities/
│   │   ├── plan_entity.dart
│   │   ├── plan_prices_entity.dart
│   │   └── plan_limits_entity.dart
│   ├── repositories/
│   │   └── plans_repository.dart
│   └── usecases/
│       └── get_plans_usecase.dart
├── data/
│   ├── models/
│   │   ├── plan_model.dart
│   │   ├── plan_prices_model.dart
│   │   └── plan_limits_model.dart
│   ├── datasources/
│   │   └── plans_remote_data_source.dart
│   └── repositories/
│       └── plans_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── plans_cubit.dart
    │   └── plans_state.dart
    ├── widgets/
    │   ├── plan_card.dart
    │   └── plan_card_skeleton.dart
    └── screens/
        └── plans_screen.dart
```

## Testing

### Manual Testing Steps

1. **Navigate to Plans**:
   - Open dashboard
   - Open drawer
   - Click "الباقات والاشتراكات"
   - Verify plans screen opens

2. **View Plans**:
   - Verify skeleton loading appears
   - Verify plans load
   - Verify 4 plans display (Diamond, Gold, Silver, Basic)
   - Verify colors are correct per tier

3. **Plan Details**:
   - Verify all plan information displays
   - Verify prices for all billing periods
   - Verify features list
   - Verify limits section
   - Verify trial badge appears

4. **Interaction**:
   - Click "اختيار هذه الباقة"
   - Verify dialog appears
   - Verify trial info shows
   - Click confirm
   - Verify SnackBar appears

5. **Refresh**:
   - Pull down to refresh
   - Verify plans reload

6. **Error Handling**:
   - Turn off network
   - Open plans screen
   - Verify error message
   - Click retry
   - Verify retry works

## Dependencies

- `flutter_bloc` - State management
- `dartz` - Functional programming
- `dio` - HTTP client
- `data_connection_checker_tv` - Network status
- `equatable` - Value equality

## Error Handling

- **Network Errors**: "لا يوجد اتصال بالإنترنت"
- **Server Errors**: Display server message
- **Empty State**: "لا توجد باقات متاحة حالياً"
- **Unknown Errors**: "Failed to load plans"

All errors shown with retry button.

## Success Feedback

- Plans load with smooth animation
- Pull-to-refresh indicator
- Selection shows confirmation dialog
- SnackBar on plan selection

## Responsive Design

- Single column layout
- Scrollable list
- Cards adapt to screen width
- Proper spacing and padding

## Accessibility

- Semantic icons
- Clear labels
- Touch-friendly buttons (48px min)
- Good color contrast

## Notes

- Plans are sorted by priority (highest first)
- Each plan has unique color scheme
- Trial period info prominent
- Current plan cannot be reselected
- Prices formatted for readability
- All text in Arabic

## Future Enhancements

- [ ] Implement actual subscription logic
- [ ] Add payment gateway integration
- [ ] Add plan comparison feature
- [ ] Add filter/sort options
- [ ] Add plan details modal
- [ ] Add subscription history
- [ ] Add plan upgrade/downgrade flow
- [ ] Cache plans locally
- [ ] Add analytics tracking
- [ ] Add promotional codes
- [ ] Add referral discounts
- [ ] Add FAQ section
- [ ] Add customer testimonials
