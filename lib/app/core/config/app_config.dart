import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

/// Application configuration class
/// Manages environment-specific settings and feature flags
class AppConfig {
  AppConfig._();

  /// Current environment
  static AppEnvironment get environment {
    if (kDebugMode) {
      return AppEnvironment.development;
    } else if (kProfileMode) {
      return AppEnvironment.staging;
    } else {
      return AppEnvironment.production;
    }
  }

  /// Check if app is running in debug mode
  static bool get isDebug => kDebugMode;

  /// Check if app is running in release mode
  static bool get isRelease => kReleaseMode;

  /// Check if app is running in profile mode
  static bool get isProfile => kProfileMode;

  /// Get API base URL based on environment
  static String get apiBaseUrl {
    switch (environment) {
      case AppEnvironment.development:
        return AppConstants.newsApiBaseUrl;
      case AppEnvironment.staging:
        return AppConstants.newsApiBaseUrl;
      case AppEnvironment.production:
        return AppConstants.newsApiBaseUrl;
    }
  }

  /// Get API key from environment variables
  static String get apiKey {
    return const String.fromEnvironment(
      AppConstants.newsApiKeyEnvVar,
      defaultValue: AppConstants.defaultApiKey,
    );
  }

  /// Check if API key is configured
  static bool get isApiKeyConfigured {
    return apiKey != AppConstants.defaultApiKey && apiKey.isNotEmpty;
  }

  /// Get app name with environment suffix
  static String get appDisplayName {
    switch (environment) {
      case AppEnvironment.development:
        return '${AppConstants.appName} (Dev)';
      case AppEnvironment.staging:
        return '${AppConstants.appName} (Staging)';
      case AppEnvironment.production:
        return AppConstants.appName;
    }
  }

  /// Enable/disable logging based on environment
  static bool get enableLogging {
    return environment != AppEnvironment.production;
  }

  /// Enable/disable crash reporting
  static bool get enableCrashReporting {
    return environment == AppEnvironment.production;
  }

  /// Enable/disable analytics
  static bool get enableAnalytics {
    return environment == AppEnvironment.production && FeatureFlags.enableAnalytics;
  }

  /// Get timeout duration based on environment
  static Duration get networkTimeout {
    switch (environment) {
      case AppEnvironment.development:
        return const Duration(seconds: 30); // Longer timeout for development
      case AppEnvironment.staging:
      case AppEnvironment.production:
        return AppConstants.connectionTimeout;
    }
  }

  /// Get page size for news articles
  static int get defaultPageSize {
    return AppConstants.defaultPageSize;
  }

  /// Get maximum page size
  static int get maxPageSize {
    return AppConstants.maxPageSize;
  }

  /// Check if feature is enabled
  static bool isFeatureEnabled(String featureName) {
    switch (featureName) {
      case 'pull_to_refresh':
        return FeatureFlags.enablePullToRefresh;
      case 'shimmer_loading':
        return FeatureFlags.enableShimmerLoading;
      case 'error_retry':
        return FeatureFlags.enableErrorRetry;
      case 'search_suggestions':
        return FeatureFlags.enableSearchSuggestions;
      case 'offline_mode':
        return FeatureFlags.enableOfflineMode;
      case 'analytics':
        return FeatureFlags.enableAnalytics;
      default:
        return false;
    }
  }

  /// Get configuration summary for debugging
  static Map<String, dynamic> get configSummary {
    return {
      'environment': environment.name,
      'isDebug': isDebug,
      'isRelease': isRelease,
      'isProfile': isProfile,
      'apiBaseUrl': apiBaseUrl,
      'isApiKeyConfigured': isApiKeyConfigured,
      'appDisplayName': appDisplayName,
      'enableLogging': enableLogging,
      'enableCrashReporting': enableCrashReporting,
      'enableAnalytics': enableAnalytics,
      'networkTimeout': networkTimeout.inSeconds,
      'defaultPageSize': defaultPageSize,
      'maxPageSize': maxPageSize,
    };
  }

  /// Print configuration summary (debug only)
  static void printConfigSummary() {
    if (isDebug) {
      debugPrint('=== App Configuration ===');
      configSummary.forEach((key, value) {
        debugPrint('$key: $value');
      });
      debugPrint('========================');
    }
  }
}

/// Application environments
enum AppEnvironment {
  development,
  staging,
  production,
}

/// Extension for AppEnvironment
extension AppEnvironmentExtension on AppEnvironment {
  String get name {
    switch (this) {
      case AppEnvironment.development:
        return 'Development';
      case AppEnvironment.staging:
        return 'Staging';
      case AppEnvironment.production:
        return 'Production';
    }
  }

  String get shortName {
    switch (this) {
      case AppEnvironment.development:
        return 'dev';
      case AppEnvironment.staging:
        return 'staging';
      case AppEnvironment.production:
        return 'prod';
    }
  }
}
