import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xnime_app/core/routes/api_endpoints.dart';
import 'package:xnime_app/pages/home_page.dart';
import 'package:xnime_app/pages/onBoarding/onboarding_screen.dart';
import 'package:xnime_app/pages/splash_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: ApiEndpoints.root,
      builder:
          (BuildContext context, GoRouterState state) => SplashScreen(
            onInitComplete: () => context.go(ApiEndpoints.onBoarding),
          ),
    ),
    GoRoute(
      path: ApiEndpoints.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: ApiEndpoints.onBoarding,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
  ],
);
