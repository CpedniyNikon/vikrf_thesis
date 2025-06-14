import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vikrf_thesis/features/analytics/presentation/analytics_screen.dart';
import 'package:vikrf_thesis/features/auth/presentation/login_screen.dart';
import 'package:vikrf_thesis/features/dashboard/presentation/dashboard_screen.dart';
import 'package:vikrf_thesis/features/devices/presentation/devices_screen.dart';
import 'package:vikrf_thesis/features/home/presentation/home_screen.dart';
import 'package:vikrf_thesis/features/settings/presentation/settings_screen.dart';

import 'dependencies/api_module.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      redirect: (_, __) async {
        debugPrint("redirect ${DateTime.now()}");
        final authAppUtil = ApiModule.authApiUtil();
        final hasToken = await authAppUtil.hasToken();
        if (hasToken.isNotEmpty) {
          return '/overview';
        }
        return null;
      },
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeIn).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/overview',
              builder: (context, state) => const DashboardScreen(),
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/devices',
              builder: (context, state) => const DevicesScreen(),
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/analytics',
              builder: (context, state) => const AnalyticsScreen(),
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            )
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/:any',
      redirect: (context, state) {
        return '/overview';
      },
    ),
  ],
);
