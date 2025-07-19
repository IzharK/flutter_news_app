/// Application-wide constants and configuration values
/// Centralized location for all constant values used throughout the app
class AppConstants {
  AppConstants._();

  /// App Information
  static const String appName = 'Flutter News App';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'A modern news application built with Flutter';

  /// API Configuration
  static const String newsApiBaseUrl = 'https://newsapi.org/v2';
  static const String newsApiKeyEnvVar = 'NEWS_API_KEY';
  static const String defaultApiKey = 'your_api_key_here';

  /// Network Configuration
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int countriesPageSize = 50;

  /// UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shimmerDuration = Duration(milliseconds: 1500);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  /// Layout Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  /// Image Configuration
  static const double newsImageAspectRatio = 16 / 9;
  static const double thumbnailSize = 80.0;
  static const double newsImageHeight = 180.0;

  /// Text Limits
  static const int shortDescriptionLength = 150;
  static const int titleMaxLines = 3;
  static const int descriptionMaxLines = 3;
  static const int compactTitleMaxLines = 2;
  static const int compactDescriptionMaxLines = 2;

  /// Reading Time Calculation
  static const int averageWordsPerMinute = 200;

  /// Error Messages
  static const String networkErrorMessage =
      'Network error occurred. Please check your connection and try again.';
  static const String timeoutErrorMessage =
      'Connection timed out. Please check your internet connection and try again.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String invalidApiKeyMessage =
      'Invalid API key. Please check your configuration.';
  static const String rateLimitMessage =
      'Too many requests. Please try again later.';
  static const String unknownErrorMessage =
      'An unexpected error occurred. Please try again.';

  /// Success Messages
  static const String refreshSuccessMessage = 'News updated successfully';
  static const String dataLoadedMessage = 'Data loaded successfully';

  /// Empty State Messages
  static const String noHeadlinesMessage = 'No headlines available';
  static const String noCountryNewsMessage =
      'No news available for the selected country';
  static const String noCategoryNewsMessage =
      'No news available for the selected category';
  static const String noSearchResultsMessage = 'No search results found';

  /// Loading Messages
  static const String loadingNewsMessage = 'Loading news...';
  static const String refreshingMessage = 'Refreshing...';
  static const String searchingMessage = 'Searching...';

  /// Button Labels
  static const String retryButtonLabel = 'Retry';
  static const String refreshButtonLabel = 'Refresh';
  static const String clearSearchLabel = 'Clear Search';
  static const String searchLabel = 'Search';

  /// Navigation Labels
  static const String headlinesTabLabel = 'Headlines';
  static const String countriesTabLabel = 'Countries';
  static const String categoriesTabLabel = 'Categories';

  /// App Bar Titles
  static const String headlinesTitle = 'Top Headlines';
  static const String countriesTitle = 'By Country';
  static const String categoriesTitle = 'Categories';

  /// Search Configuration
  static const String searchHint = 'Search news...';
  static const String searchTipsMessage =
      'Use quotes for exact phrases, + for required words';

  /// Accessibility Labels
  static const String newsImageAccessibilityLabel = 'News article image';
  static const String sourceAccessibilityLabel = 'News source';
  static const String publishedTimeAccessibilityLabel = 'Published time';
  static const String authorAccessibilityLabel = 'Article author';
  static const String readingTimeAccessibilityLabel = 'Estimated reading time';
}

/// Route constants for navigation
class RouteConstants {
  RouteConstants._();

  static const String headlines = '/headlines';
  static const String countries = '/countries';
  static const String categories = '/categories';
}

/// Asset paths for images, icons, and other resources
class AssetConstants {
  AssetConstants._();

  // If you add assets later, define them here
  // static const String appLogo = 'assets/images/logo.png';
  // static const String placeholderImage = 'assets/images/placeholder.png';
}

/// Theme-related constants
class ThemeConstants {
  ThemeConstants._();

  /// Elevation values
  static const double cardElevation = 0.0;
  static const double appBarElevation = 1.0;
  static const double bottomNavElevation = 8.0;

  /// Border widths
  static const double thinBorderWidth = 1.0;
  static const double mediumBorderWidth = 2.0;

  /// Icon sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 48.0;
  static const double extraLargeIconSize = 64.0;
}

/// Debug and development constants
class DebugConstants {
  DebugConstants._();

  static const bool enableApiLogging = true;
  static const bool enablePerformanceLogging = false;
  static const bool enableNetworkLogging = true;
}

/// Feature flags for enabling/disabling features
class FeatureFlags {
  FeatureFlags._();

  static const bool enablePullToRefresh = true;
  static const bool enableShimmerLoading = true;
  static const bool enableErrorRetry = true;
  static const bool enableSearchSuggestions = false;
  static const bool enableOfflineMode = false;
  static const bool enableAnalytics = false;
}
