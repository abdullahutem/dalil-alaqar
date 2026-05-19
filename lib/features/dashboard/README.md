# Dashboard Feature

## Overview
The Dashboard feature provides a comprehensive overview of the real estate office's statistics, including properties, employees, views, subscription information, and recent activities. This feature is **only accessible to logged-in users**.

## Architecture
This feature follows Clean Architecture principles with three main layers:

### 1. Domain Layer (`domain/`)
- **Entities**: Core business objects
  - `DashboardStatsEntity`: Main dashboard statistics container
  - `PropertiesStats`: Properties statistics (total, available, reserved, sold, rented, this month)
  - `EmployeesStats`: Employees statistics (total, active, inactive)
  - `ViewsStats`: Views statistics (total, this month)
  - `SubscriptionInfo`: Subscription details (plan name, status, end date, days remaining)
  - `LimitsInfo`: Property limits (max properties, used properties, can add more)
  - `RecentPropertyEntity`: Recent property details
  - `TopViewedPropertyEntity`: Top viewed property details

- **Repositories**: Abstract repository interface
  - `DashboardRepository`: Defines contract for data operations

- **Use Cases**: Business logic
  - `GetDashboardStatsUseCase`: Fetches dashboard statistics

### 2. Data Layer (`data/`)
- **Models**: Data transfer objects with JSON serialization
  - `DashboardStatsModel`: Extends `DashboardStatsEntity` with `fromJson`
  - All nested models with JSON parsing

- **Data Sources**: API communication
  - `DashboardRemoteDataSource`: Interface for remote data operations
  - `DashboardRemoteDataSourceImpl`: Implementation using API consumer

- **Repositories**: Implementation of domain repositories
  - `DashboardRepositoryImpl`: Implements `DashboardRepository` with network handling

### 3. Presentation Layer (`presentation/`)
- **Cubit**: State management
  - `DashboardCubit`: Manages dashboard state and business logic
  - `DashboardState`: State definitions (Initial, Loading, Success, Error)

- **Screens**: UI screens
  - `DashboardScreen`: Main dashboard screen with all statistics
  - `DashboardExampleScreen`: Example demonstrating navigation to dashboard

- **Widgets**: Reusable UI components
  - `StatCard`: Displays individual statistics with icon and color
  - `SubscriptionCard`: Shows subscription and limits information
  - `PropertyListItem`: Displays recent property details
  - `TopViewedItem`: Shows top viewed property with ranking
  - `DashboardDrawer`: Navigation drawer for dashboard
  - `DashboardSkeleton`: Skeleton loading animation

## API Endpoint

### Get Dashboard Stats
**Endpoint**: `office/dashboard`  
**Method**: GET  
**Authentication**: Required (logged-in users only)

**Response Structure**:
```json
{
  "success": true,
  "message": "",
  "data": {
    "properties": {
      "total": 11,
      "available": 5,
      "reserved": 3,
      "sold": 3,
      "rented": 0,
      "this_month": 11
    },
    "employees": {
      "total": 1,
      "active": 1,
      "inactive": 0
    },
    "views": {
      "total": "9188",
      "this_month": "9188"
    },
    "subscription": {
      "plan_name": "الباقة الأساسية",
      "status": "active",
      "end_date": "2026-09-03",
      "days_remaining": 106,
      "is_expiring_soon": false
    },
    "limits": {
      "max_properties": 30,
      "used_properties": 11,
      "can_add_more": true
    },
    "recent_properties": [...],
    "top_viewed_properties": [...]
  }
}
```

## Features

### 1. Statistics Cards
- **Total Properties**: Shows total count and this month's additions
- **Available Properties**: Count of available properties
- **Reserved Properties**: Count of reserved properties
- **Sold Properties**: Count of sold properties
- **Total Employees**: Shows total and active employees
- **Total Views**: Shows total views and this month's views

Each card features:
- Color-coded icons
- Large value display
- Descriptive title
- Optional subtitle with additional info

### 2. Subscription Card
Displays subscription information with:
- Plan name in Arabic
- Active/Inactive status badge
- End date
- Days remaining (with warning if expiring soon)
- Property usage limits (used/max)
- Can add more indicator

Visual features:
- Gradient background (blue for active, grey for inactive)
- Warning icon for expiring subscriptions
- Progress indicator for property limits

### 3. Recent Properties List
Shows the 5 most recent properties with:
- Property title
- Status badge (available, reserved, sold, rented)
- Property type and offer type
- Location (governorate)
- Price
- Views count
- Creation date

### 4. Top Viewed Properties List
Shows the 5 most viewed properties with:
- Ranking badge (trophy icons for top 3)
- Property title
- Property type and offer type
- Views count in highlighted badge

Special styling for top 3:
- Gold trophy for #1
- Silver trophy for #2
- Bronze trophy for #3
- Colored borders matching rank

### 5. Navigation Drawer
Provides quick access to:
- Dashboard (current)
- My Properties
- Add New Property
- Employees
- Reports
- Subscription
- Settings
- Help
- Logout

Features:
- User profile section with avatar
- Organized menu items with icons
- Logout confirmation dialog

### 6. Loading States
- **Skeleton Loading**: Shimmer effect while loading data
- **Pull to Refresh**: Swipe down to refresh dashboard
- **Error Handling**: User-friendly error messages with retry button

## Usage

### Basic Implementation

```dart
import 'package:dalil_alaqar/features/dashboard/presentation/screens/dashboard_screen.dart';

// Navigate to dashboard (only for logged-in users)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DashboardScreen()),
);
```

### With Authentication Check

```dart
// In your navigation bar or main app
Widget build(BuildContext context) {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      // Only show dashboard for logged-in users
      if (isUserLoggedIn)
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ],
    onTap: (index) {
      if (index == 1 && isUserLoggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    },
  );
}
```

### Cubit Factory Pattern

The dashboard uses a factory method for dependency injection:

```dart
// Automatic dependency injection
BlocProvider(
  create: (context) => DashboardCubit.create()..getDashboardStats(),
  child: const DashboardContent(),
);
```

### Manual Refresh

```dart
// Refresh dashboard data
context.read<DashboardCubit>().refresh();
```

## State Management

### States
1. **DashboardInitial**: Initial state before loading
2. **DashboardLoading**: Loading data from API
3. **DashboardSuccess**: Data loaded successfully
4. **DashboardError**: Error occurred during loading

### State Flow
```
Initial → Loading → Success/Error
         ↑         ↓
         └─ Refresh ─┘
```

## Customization

### Changing Colors
Edit the color scheme in widgets:
- `StatCard`: Modify `color` parameter
- `SubscriptionCard`: Edit gradient colors
- Status badges: Update `_getStatusColor()` methods

### Adding New Stats
1. Add entity to `DashboardStatsEntity`
2. Add model with JSON parsing
3. Update API response handling
4. Create new `StatCard` in dashboard screen

### Modifying Drawer Items
Edit `DashboardDrawer` widget:
- Add new menu items with `_buildDrawerItem()`
- Update navigation logic in `onTap` callbacks

## Dependencies

Required packages:
- `flutter_bloc`: State management
- `dartz`: Functional programming (Either type)
- `dio`: HTTP client
- `data_connection_checker_tv`: Network connectivity
- `shimmer`: Skeleton loading animation

## Error Handling

The feature handles various error scenarios:
- Network errors
- API errors
- Parsing errors
- Authentication errors

All errors are displayed with:
- Error icon
- Error message
- Retry button

## Performance Considerations

1. **Lazy Loading**: Dashboard loads only when accessed
2. **Caching**: Consider implementing caching for better performance
3. **Skeleton Loading**: Provides immediate visual feedback
4. **Pull to Refresh**: Manual refresh option for users

## Security

- Dashboard is only accessible to authenticated users
- API endpoint requires authentication token
- Sensitive data should be handled securely
- Implement proper session management

## Testing

### Unit Tests
Test the following components:
- `DashboardCubit`: State transitions and business logic
- `GetDashboardStatsUseCase`: Use case execution
- Models: JSON parsing and serialization

### Widget Tests
Test UI components:
- `DashboardScreen`: Rendering different states
- `StatCard`: Display of statistics
- `SubscriptionCard`: Subscription information display

### Integration Tests
Test complete flows:
- Loading dashboard data
- Refreshing dashboard
- Error handling and retry

## Future Enhancements

Potential improvements:
1. Real-time updates using WebSockets
2. Customizable dashboard layout
3. Export statistics to PDF/Excel
4. Date range filters for statistics
5. Comparison with previous periods
6. Charts and graphs for visual analytics
7. Push notifications for important events
8. Offline support with local caching

## Troubleshooting

### Dashboard not loading
- Check authentication status
- Verify API endpoint configuration
- Check network connectivity
- Review API response format

### Skeleton loading stuck
- Check for API timeout
- Verify error handling in cubit
- Check network connection

### Data not refreshing
- Verify refresh logic in cubit
- Check API response
- Clear app cache if needed

## File Structure

```
dashboard/
├── data/
│   ├── datasources/
│   │   └── dashboard_remote_data_source.dart
│   ├── models/
│   │   └── dashboard_stats_model.dart
│   └── repositories/
│       └── dashboard_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── dashboard_stats_entity.dart
│   ├── repositories/
│   │   └── dashboard_repository.dart
│   └── usecases/
│       └── get_dashboard_stats_usecase.dart
├── presentation/
│   ├── cubit/
│   │   ├── dashboard_cubit.dart
│   │   └── dashboard_state.dart
│   ├── screens/
│   │   ├── dashboard_screen.dart
│   │   └── dashboard_example_screen.dart
│   └── widgets/
│       ├── dashboard_drawer.dart
│       ├── dashboard_skeleton.dart
│       ├── property_list_item.dart
│       ├── stat_card.dart
│       ├── subscription_card.dart
│       └── top_viewed_item.dart
└── README.md
```

## Support

For issues or questions:
1. Check this documentation
2. Review example implementation
3. Check API endpoint configuration
4. Verify authentication setup
5. Contact development team

---

**Note**: This feature requires user authentication. Ensure proper authentication flow is implemented before integrating the dashboard.
