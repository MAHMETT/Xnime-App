import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xnime_app/core/routes/api_endpoints.dart';
import 'package:xnime_app/main.dart';
import 'package:xnime_app/pages/detail_page.dart';
import 'package:xnime_app/pages/stream_page.dart';
import 'package:xnime_app/pages/explore_page.dart';
import 'package:xnime_app/pages/home/completed_page.dart';
import 'package:xnime_app/pages/home_page.dart';
import 'package:xnime_app/pages/onBoarding/onboarding_screen.dart';
import 'package:xnime_app/pages/home/ongoing_page.dart';
import 'package:xnime_app/pages/search_page.dart';
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
      path: ApiEndpoints.mainPage,
      builder: (BuildContext context, GoRouterState state) {
        return const MainPage();
      },
    ),
    GoRoute(
      path: ApiEndpoints.onBoarding,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: ApiEndpoints.explore,
      builder: (BuildContext context, GoRouterState state) {
        return const ExplorePage();
      },
    ),
    GoRoute(
      path: ApiEndpoints.ongoing,
      builder: (BuildContext context, GoRouterState state) {
        return const OngoingPage();
      },
    ),
    GoRoute(
      path: ApiEndpoints.completed,
      builder: (BuildContext context, GoRouterState state) {
        return const CompletedPage();
      },
    ),
    GoRoute(
      path: ApiEndpoints.search,
      builder: (BuildContext context, GoRouterState state) {
        return const SearchPage();
      },
    ),
    GoRoute(
      path: '/anime/:animeId',
      builder: (context, state) {
        final animeId = state.pathParameters['animeId'];
        if (animeId == null) {
          return const Scaffold(
            body: Center(child: Text('Anime ID not found')),
          );
        }
        return DetailPage(animeId: animeId);
      },
    ),
    GoRoute(
      path: '/episode/:animeId',
      builder: (context, state) {
        final animeId = state.pathParameters['animeId'];
        if (animeId == null) {
          return const Scaffold(
            body: Center(child: Text('Anime ID not found')),
          );
        }
        return StreamPage(animeId: animeId);
      },
    ),
  ],
);
