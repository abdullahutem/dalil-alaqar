# Dashboard Feature - Quick Start Guide

## 🚀 Get Started in 3 Steps

### Step 1: Import the Dashboard
```dart
import 'package:dalil_alaqar/features/dashboard/presentation/screens/dashboard_screen.dart';
```

### Step 2: Navigate to Dashboard
```dart
// Simple navigation
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DashboardScreen()),
);
```

### Step 3: Add to Your Navigation Bar
```dart
// Only show for logged-in users
if (isUserLoggedIn)
  BottomNavigationBarItem(
    icon: Icon(Icons.dashboard),
    label: 'لوحة التحكم',
  ),
```

## 📋 What You Get

### 6 Statistics Cards
- Total Properties (with this month count)
- Available Properties
- Reserved Properties
- Sold Properties
- Total Employees (with active count)
- Total Views (with this month count)

### Subscription Card
- Plan name
- Status badge
- End date
- Days remaining
- Property limits (used/max)
- Can add more indicator

### Recent Properties List
- 5 most recent properties
- Status badges
- Property details
- Views count

### Top Viewed Properties List
- 5 most viewed properties
- Ranking badges (trophy icons)
- Views count

### Navigation Drawer
- Quick access menu
- User profile
- Logout option

## 🎨 Features

✅ Skeleton loading animation  
✅ Pull-to-refresh  
✅ Error handling with retry  
✅ Responsive design  
✅ Arabic interface  
✅ Color-coded statistics  
✅ Material Design icons  

## 🔐 Authentication Required

The dashboard is **only for logged-in users**. Make sure to:
1. Check authentication status before showing dashboard icon
2. Add authentication token to API requests
3. Handle unauthorized access

## 📡 API Endpoint

**Endpoint**: `office/dashboard`  
**Method**: GET  
**Auth**: Required  

## 🎯 Example Usage

```dart
import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/screens/dashboard_screen.dart';

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn = true; // Get from your auth state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My App')),
      body: Center(
        child: ElevatedButton(
          onPressed: isUserLoggedIn
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                }
              : null,
          child: Text('Open Dashboard'),
        ),
      ),
    );
  }
}
```

## 📚 More Information

- **Full Documentation**: See [README.md](README.md)
- **Integration Guide**: See [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)
- **Implementation Details**: See [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)

## 🐛 Troubleshooting

**Dashboard not loading?**
- Check authentication token
- Verify API endpoint configuration
- Check network connection

**Icon not showing?**
- Verify authentication status
- Check conditional rendering logic

**Error on screen?**
- Check API response format
- Verify endpoint URL
- Review error message

## 💡 Tips

1. **Test with example screen first**:
   ```dart
   import 'package:dalil_alaqar/features/dashboard/presentation/screens/dashboard_example_screen.dart';
   
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const DashboardExampleScreen()),
   );
   ```

2. **Use pull-to-refresh** to reload data

3. **Check the drawer** for navigation options

4. **Customize colors** in widget files to match your theme

## ✅ Checklist

Before deploying:
- [ ] Authentication is working
- [ ] API endpoint is configured
- [ ] Auth token is included in requests
- [ ] Dashboard icon shows only for logged-in users
- [ ] Navigation works correctly
- [ ] Data loads successfully
- [ ] Error handling works
- [ ] Refresh functionality works
- [ ] Drawer navigation works
- [ ] Tested on different screen sizes

## 🎉 You're Ready!

The dashboard is fully implemented and ready to use. Just integrate it into your navigation and ensure authentication is set up correctly.

---

**Need Help?** Check the full documentation in [README.md](README.md)
