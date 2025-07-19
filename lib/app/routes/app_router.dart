import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/categories_view.dart';
import '../views/countries_view.dart';
import '../views/headlines_view.dart';
import '../views/scaffold_with_nav_bar.dart';

/// Enhanced app router with better error handling and navigation management
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Route paths constants for better maintainability
  static const String headlinesPath = '/headlines';
  static const String countriesPath = '/countries';
  static const String categoriesPath = '/categories';

  /// Get the current context from the root navigator
  static BuildContext? get currentContext => _rootNavigatorKey.currentContext;

  /// Navigate to a specific route
  static void navigateTo(String path) {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(path);
    }
  }

  /// Navigate to headlines
  static void goToHeadlines() => navigateTo(headlinesPath);

  /// Navigate to countries
  static void goToCountries() => navigateTo(countriesPath);

  /// Navigate to categories
  static void goToCategories() => navigateTo(categoriesPath);

  /// Check if current route matches the given path
  static bool isCurrentRoute(String path) {
    if (currentContext == null) return false;
    final currentLocation = GoRouterState.of(currentContext!).uri.path;
    return currentLocation == path;
  }

  /// Get current route index for bottom navigation
  static int getCurrentRouteIndex() {
    if (currentContext == null) return 0;
    final currentLocation = GoRouterState.of(currentContext!).uri.path;

    switch (currentLocation) {
      case headlinesPath:
        return 0;
      case countriesPath:
        return 1;
      case categoriesPath:
        return 2;
      default:
        return 0;
    }
  }

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: headlinesPath,
    debugLogDiagnostics: true,

    // Error handling
    errorBuilder: (context, state) => _ErrorPage(error: state.error),

    // Redirect logic for invalid routes
    redirect: (context, state) {
      final validPaths = [headlinesPath, countriesPath, categoriesPath];
      if (!validPaths.contains(state.uri.path)) {
        return headlinesPath;
      }
      return null;
    },

    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: headlinesPath,
            name: 'headlines',
            builder: (context, state) => const HeadlinesView(),
            pageBuilder: (context, state) =>
                _buildPageWithTransition(context, state, const HeadlinesView()),
          ),
          GoRoute(
            path: countriesPath,
            name: 'countries',
            builder: (context, state) => const CountriesView(),
            pageBuilder: (context, state) =>
                _buildPageWithTransition(context, state, const CountriesView()),
          ),
          GoRoute(
            path: categoriesPath,
            name: 'categories',
            builder: (context, state) => const CategoriesView(),
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const CategoriesView(),
            ),
          ),
        ],
      ),
    ],
  );

  /// Build page with custom transition animation
  static Page<void> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }
}

/// Error page widget for handling navigation errors
class _ErrorPage extends StatelessWidget {
  final Exception? error;

  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Navigation Error',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error?.toString() ?? 'An unknown error occurred',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => AppRouter.goToHeadlines(),
                icon: const Icon(Icons.home),
                label: const Text('Go to Headlines'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
