import 'package:dalil_alaqar/core/constants/app_constants.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/localization/locale_cubit.dart';
import 'package:dalil_alaqar/core/localization/locale_state.dart';
import 'package:dalil_alaqar/core/routes/app_router.dart';
import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:dalil_alaqar/core/theme/app_theme.dart';
import 'package:dalil_alaqar/core/theme/theme_cubit.dart';
import 'package:dalil_alaqar/core/theme/theme_state.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize cache helper
  await CacheHelper().init();
  // DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => MyApp(), // Wrap your app
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => AuthCubit.create()..checkAuthStatus()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRouter.onGenerateRoute,
                locale: localeState.locale,
                supportedLocales: const [
                  Locale('ar', 'SA'),
                  Locale('en', 'US'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
            },
          );
        },
      ),
    );
  }
}
