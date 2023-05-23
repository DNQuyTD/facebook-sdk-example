import 'package:fexample/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/screen_0.dart';
import '../screens/screen_1.dart';
import '../screens/screen_2.dart';

class NavigationService {
  final AnalyticsService analyticService;
  late GoRouter _router;

  NavigationService(this.analyticService) {
    _router = GoRouter(
      observers: [analyticService.getFbAnalyticsObserver()],
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'Home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeRoute();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'first-page',
              name: 'First',
              builder: (BuildContext context, GoRouterState state) {
                return const FirstRoute();
              },
            ),
            GoRoute(
              path: 'second-page',
              name: 'Second',
              builder: (BuildContext context, GoRouterState state) {
                return const SecondRoute();
              },
            ),
          ],
        ),
      ],
    );
  }

  GoRouter getRouter() => _router;
}
