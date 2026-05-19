# Dashboard Integration Guide

## Quick Start

This guide shows you how to integrate the Dashboard feature into your app's navigation.

## Step 1: Import the Dashboard Screen

```dart
import 'package:dalil_alaqar/features/dashboard/presentation/screens/dashboard_screen.dart';
```

## Step 2: Add to Navigation Bar (Conditional)

The dashboard should only be visible to logged-in users. Here's how to implement it:

### Option A: Bottom Navigation Bar

```dart
class MainScreen extends StatefulWidget {
  final bool isUserLoggedIn; // Pass this from your auth state
  
  const MainScreen({super.key, required this.isUserLoggedIn});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Build navigation items based on auth status
    final List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'الرئيسية',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'بحث',
      ),
      // Only add dashboard for logged-in users
      if (widget.isUserLoggedIn)
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'لوحة التحكم',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'الحساب',
      ),
    ];

    return Scaffold(
      body: _getBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navItems,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _getBody(int index) {
    // Adjust indices based on whether dashboard is included
    if (widget.isUserLoggedIn) {
      switch (index) {
        case 0:
          return const HomeScreen();
        case 1:
          return const SearchScreen();
        case 2:
          return const DashboardScreen();
        case 3:
          return const ProfileScreen();
        default:
          return const HomeScreen();
      }
    } else {
      switch (index) {
        case 0:
          return const HomeScreen();
        case 1:
          return const SearchScreen();
        case 2:
          return const ProfileScreen();
        default:
          return const HomeScreen();
      }
    }
  }
}
```

### Option B: Drawer Navigation

```dart
class AppDrawer extends StatelessWidget {
  final bool isUserLoggedIn;
  
  const AppDrawer({super.key, required this.isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'دليل العقار',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('الرئيسية'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to home
            },
          ),
          // Only show dashboard for logged-in users
          if (isUserLoggedIn)
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('لوحة التحكم'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
        ],
      ),
    );
  }
}
```

### Option C: Direct Navigation (Button/Card)

```dart
// In your profile or home screen
if (isUserLoggedIn)
  Card(
    child: ListTile(
      leading: const Icon(Icons.dashboard, color: Colors.blue),
      title: const Text('لوحة التحكم'),
      subtitle: const Text('عرض الإحصائيات والتقارير'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      },
    ),
  ),
```

## Step 3: Authentication State Management

### Using Provider

```dart
import 'package:provider/provider.dart';

// Auth Provider
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  
  bool get isLoggedIn => _isLoggedIn;
  
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }
  
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

// In your main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

// In your navigation widget
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          if (isLoggedIn)
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'لوحة التحكم',
            ),
        ],
      ),
    );
  }
}
```

### Using BLoC

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Auth State
abstract class AuthState {}
class AuthInitial extends AuthState {}
class Authenticated extends AuthState {}
class Unauthenticated extends AuthState {}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  
  void login() => emit(Authenticated());
  void logout() => emit(Unauthenticated());
}

// In your navigation widget
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoggedIn = state is Authenticated;
        
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              if (isLoggedIn)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'لوحة التحكم',
                ),
            ],
          ),
        );
      },
    );
  }
}
```

## Step 4: API Configuration

Ensure the dashboard endpoint is configured in your API settings:

```dart
// lib/core/databases/api/end_points.dart
class EndPoints {
  static const String baseUrl = 'https://your-api.com/api/';
  static const String dashboard = 'office/dashboard';
  // ... other endpoints
}
```

## Step 5: Authentication Token

Make sure your API consumer includes the authentication token:

```dart
// In your DioConsumer or API interceptor
class DioConsumer implements ApiConsumer {
  final Dio dio;
  
  DioConsumer({required this.dio}) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to headers
          final token = getAuthToken(); // Get from secure storage
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}
```

## Step 6: Handle Unauthorized Access

Add error handling for unauthorized access:

```dart
// In your navigation logic
void navigateToDashboard(BuildContext context) {
  if (!isUserLoggedIn) {
    // Show login dialog or navigate to login
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الدخول مطلوب'),
        content: const Text('يجب تسجيل الدخول للوصول إلى لوحة التحكم'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
    return;
  }
  
  // User is logged in, navigate to dashboard
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DashboardScreen()),
  );
}
```

## Complete Example

Here's a complete example integrating everything:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AuthCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دليل العقار',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final isLoggedIn = authState is Authenticated;
        
        final List<Widget> screens = [
          const HomeScreen(),
          const SearchScreen(),
          if (isLoggedIn) const DashboardScreen(),
          const ProfileScreen(),
        ];

        final List<BottomNavigationBarItem> navItems = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'بحث',
          ),
          if (isLoggedIn)
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'لوحة التحكم',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الحساب',
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: navItems,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          ),
        );
      },
    );
  }
}
```

## Testing the Integration

1. **Test without login**: Dashboard icon should not appear
2. **Test with login**: Dashboard icon should appear and be accessible
3. **Test navigation**: Clicking dashboard should load the screen
4. **Test data loading**: Dashboard should show skeleton then data
5. **Test refresh**: Pull-to-refresh should reload data
6. **Test drawer**: Drawer should open and navigate correctly

## Troubleshooting

### Dashboard icon not showing
- Check authentication state
- Verify conditional rendering logic
- Check BLoC/Provider setup

### Dashboard shows error
- Verify API endpoint configuration
- Check authentication token
- Review network connectivity
- Check API response format

### Navigation not working
- Verify route configuration
- Check context availability
- Review navigation logic

## Next Steps

After integration:
1. Test with real API
2. Implement proper authentication flow
3. Add error handling for edge cases
4. Customize colors and styling
5. Add analytics tracking
6. Implement deep linking (optional)

---

For more details, see the main [README.md](README.md) file.
