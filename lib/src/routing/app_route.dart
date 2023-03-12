import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:training_flutter_firebase/src/features/about/presentation/about_screen.dart';
import 'package:training_flutter_firebase/src/features/home/presentation/home_screen.dart';
import 'package:training_flutter_firebase/src/service/navigation_service.dart';

enum AppRoute {
  home,
  about,
}

final List<GoRoute> routes = [
  GoRoute(
    name: AppRoute.home.name,
    path: '/',
    builder: (context, state) => const HomeScreen(),
    routes: [
      GoRoute(
        name: AppRoute.about.name,
        path: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  ),
];

final routesProvider = Provider((ref) {
  final navRoute = NavigationService();
  return GoRouter(
    routes: routes,
    initialLocation: '/',
    refreshListenable: navRoute,
    redirect: (context, state) {
      if (navRoute.route == 'about') {
        return '/about';
      } else {
        return null;
      }
    },
  );
});
