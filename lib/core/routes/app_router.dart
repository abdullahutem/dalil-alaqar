import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:dalil_alaqar/features/auth/presentation/screens/login_screen.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/employees_screen.dart';
import 'package:dalil_alaqar/features/home/presentation/screens/home_screen.dart';
import 'package:dalil_alaqar/features/main/presentation/screens/main_screen.dart';
import 'package:dalil_alaqar/features/office_details/presentation/screens/office_details_screen.dart';
import 'package:dalil_alaqar/features/office_info/presentation/screens/office_info_screen.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/property_details_screen.dart';
import 'package:dalil_alaqar/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case AppRoutes.main:
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case AppRoutes.employeesScreen:
        return MaterialPageRoute(builder: (context) => const EmployeesScreen());
      case AppRoutes.officeInfoScreen:
        return MaterialPageRoute(
          builder: (context) => const OfficeInfoScreen(),
        );
      case AppRoutes.propertyDetailsScreen:
        final propertyId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => PropertyDetailsScreen(propertyId: propertyId),
        );
      case AppRoutes.officeDetails:
        final officeId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => OfficeDetailsScreen(officeId: officeId),
        );
      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
