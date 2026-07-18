import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'design_system/app_colors.dart';
import 'design_system/app_theme.dart';
import 'features/flight_detail/flight_detail_screen.dart';
import 'features/home/home_screen.dart';
import 'features/search/flight_search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.night,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: CirravaApp()));
}

class CirravaApp extends StatefulWidget {
  const CirravaApp({super.key});

  @override
  State<CirravaApp> createState() => _CirravaAppState();
}

class _CirravaAppState extends State<CirravaApp> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/search',
        builder: (context, state) => const FlightSearchScreen(),
      ),
      GoRoute(
        path: '/flight/:flightId',
        builder: (context, state) =>
            FlightDetailScreen(flightId: state.pathParameters['flightId']!),
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cirrava',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
