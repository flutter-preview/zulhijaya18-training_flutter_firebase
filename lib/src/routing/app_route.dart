import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:training_flutter_firebase/src/features/about/presentation/about_screen.dart';
import 'package:training_flutter_firebase/src/features/home/presentation/home_screen.dart';
import 'package:training_flutter_firebase/src/features/profile/presentation/profile_screen.dart';

class AppRoute {
  static String home = 'home', about = 'about', profile = 'profile';
}

final List<GoRoute> routes = [
  GoRoute(
    name: AppRoute.home,
    path: '/',
    builder: (context, state) => const HomeScreen(),
    routes: [
      GoRoute(
        name: AppRoute.about,
        path: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        name: AppRoute.profile,
        path: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  ),
];

final routesProvider = Provider((ref) {
  return GoRouter(
    routes: routes,
    initialLocation: '/',
    redirect: (context, state) {},
  );
});
