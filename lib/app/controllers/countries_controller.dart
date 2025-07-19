import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/news_article.dart';
import '../services/news_service.dart';

/// Controller for managing country-specific news functionality
/// Handles country selection, news fetching by country, and state management
/// Now supports all world countries using the country_picker package
class CountriesController extends GetxController {
  final NewsService _newsService = Get.find();

  /// Currently selected country (using Country object from country_picker)
  final Rx<Country?> selectedCountry = Rx<Country?>(null);

  /// List of NewsAPI supported countries for better user experience
  /// These countries are more likely to have news available
  final List<String> _newsApiSupportedCountries = [
    'ae',
    'ar',
    'at',
    'au',
    'be',
    'bg',
    'br',
    'ca',
    'ch',
    'cn',
    'co',
    'cu',
    'cz',
    'de',
    'eg',
    'fr',
    'gb',
    'gr',
    'hk',
    'hu',
    'id',
    'ie',
    'il',
    'in',
    'it',
    'jp',
    'kr',
    'lt',
    'lv',
    'ma',
    'mx',
    'my',
    'ng',
    'nl',
    'no',
    'nz',
    'ph',
    'pl',
    'pt',
    'ro',
    'rs',
    'ru',
    'sa',
    'se',
    'sg',
    'si',
    'sk',
    'th',
    'tr',
    'tw',
    'ua',
    'us',
    've',
    'za',
  ];

  /// Reactive list of news articles for the selected country
  final RxList<NewsArticle> articles = <NewsArticle>[].obs;

  /// Manages loading state for the country news view
  final RxBool isLoading = false.obs;

  /// Holds any error message that occurs during fetch
  final RxString errorMessage = ''.obs;

  /// Tracks if initial data has been loaded
  final RxBool hasInitialData = false.obs;

  /// Tracks if the current country is supported by NewsAPI
  final RxBool isCurrentCountrySupported = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultCountry();
  }

  /// Initialize with the United States as default
  void _initializeDefaultCountry() {
    // Set United States as default
    final defaultCountry = Country.parse('US');
    selectedCountry.value = defaultCountry;
    fetchNewsByCountry(defaultCountry.countryCode);
  }

  /// Select a country and fetch its news
  /// [country] - Country object from country_picker
  Future<void> selectCountry(Country country) async {
    if (selectedCountry.value?.countryCode != country.countryCode) {
      selectedCountry.value = country;
      await fetchNewsByCountry(country.countryCode);
    }
  }

  /// Fetch news articles for a specific country
  /// [countryCode] - ISO 3166-1 alpha-2 country code
  Future<void> fetchNewsByCountry(String countryCode) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _newsService.getTopHeadlines(
        country: countryCode,
        pageSize: 50, // Get more articles for country view
      );

      final articlesData = response['articles'] as List? ?? [];
      articles.value = articlesData
          .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
          .toList();

      // Mark as successful
      hasInitialData.value = true;
      isCurrentCountrySupported.value = true;
    } catch (e) {
      await _handleCountryError(countryCode, e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle errors when fetching news for a country
  Future<void> _handleCountryError(String countryCode, dynamic error) async {
    final errorString = error.toString().toLowerCase();

    // Check if it's a country-specific error
    if (_isCountryNotSupportedError(errorString)) {
      isCurrentCountrySupported.value = false;

      // Provide helpful error message
      final countryName = getCountryName(countryCode);
      errorMessage.value =
          'News is not available for $countryName at the moment. '
          'This country may not be supported by our news provider. '
          'Try selecting a different country or check back later.';

      // Clear articles for unsupported countries to avoid confusion
      articles.clear();

      // Show user-friendly snackbar
      _showCountryNotSupportedSnackbar(countryName);
    } else if (_isApiKeyError(errorString)) {
      errorMessage.value =
          'API configuration error. Please check your news API key.';
    } else if (_isNetworkError(errorString)) {
      errorMessage.value =
          'Network error. Please check your internet connection and try again.';
    } else if (_isRateLimitError(errorString)) {
      errorMessage.value =
          'Too many requests. Please wait a moment and try again.';
    } else {
      // Generic error handling
      errorMessage.value =
          'Unable to load news for this country. Please try again later.';
    }
  }

  /// Check if the error indicates the country is not supported
  bool _isCountryNotSupportedError(String errorString) {
    return errorString.contains('country') &&
        (errorString.contains('not') ||
            errorString.contains('invalid') ||
            errorString.contains('unsupported') ||
            errorString.contains('400') ||
            errorString.contains('bad request'));
  }

  /// Check if the error is related to API key
  bool _isApiKeyError(String errorString) {
    return errorString.contains('401') ||
        errorString.contains('unauthorized') ||
        errorString.contains('api key');
  }

  /// Check if the error is network-related
  bool _isNetworkError(String errorString) {
    return errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket');
  }

  /// Check if the error is rate limit related
  bool _isRateLimitError(String errorString) {
    return errorString.contains('429') ||
        errorString.contains('rate limit') ||
        errorString.contains('too many');
  }

  /// Show user-friendly snackbar for unsupported countries
  void _showCountryNotSupportedSnackbar(String countryName) {
    Get.snackbar(
      'Country Not Supported',
      'News is not available for $countryName. Try selecting a country from the favorites section.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(
        Icons.info_outline,
        color: Get.theme.colorScheme.onErrorContainer,
      ),
      mainButton: TextButton(
        onPressed: () => suggestAlternativeCountry(),
        child: Text(
          'Suggest',
          style: TextStyle(
            color: Get.theme.colorScheme.onErrorContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Suggest an alternative supported country
  void suggestAlternativeCountry() {
    // Close current snackbar
    Get.closeCurrentSnackbar();

    // Suggest a popular supported country
    final suggestions = ['US', 'GB', 'CA', 'AU', 'DE'];
    final currentCode = selectedCountry.value?.countryCode;

    // Find a suggestion that's not the current country
    final suggestion = suggestions.firstWhere(
      (code) => code != currentCode,
      orElse: () => 'US',
    );

    final suggestedCountry = Country.parse(suggestion);

    Get.snackbar(
      'Try ${suggestedCountry.displayName}',
      'Would you like to see news from ${suggestedCountry.displayName} instead?',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      colorText: Get.theme.colorScheme.onPrimaryContainer,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: Text(
        suggestedCountry.flagEmoji,
        style: const TextStyle(fontSize: 20),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
          selectCountry(suggestedCountry);
        },
        child: Text(
          'Yes',
          style: TextStyle(
            color: Get.theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Refresh news for the currently selected country
  Future<void> refreshNews() async {
    if (selectedCountry.value != null) {
      await fetchNewsByCountry(selectedCountry.value!.countryCode);
    }
  }

  /// Get country name by country code
  String getCountryName(String countryCode) {
    try {
      final country = Country.parse(countryCode);
      return country.displayName;
    } catch (e) {
      return countryCode.toUpperCase();
    }
  }

  /// Get flag emoji for country code using country_picker
  String getCountryFlag(String countryCode) {
    try {
      final country = Country.parse(countryCode);
      return country.flagEmoji;
    } catch (e) {
      return '🌍';
    }
  }

  /// Check if a country is currently selected
  bool isCountrySelected(String countryCode) {
    return selectedCountry.value?.countryCode == countryCode;
  }

  /// Get total number of articles for the selected country
  int get totalArticles => articles.length;

  /// Check if there are any articles to display
  bool get hasArticles => articles.isNotEmpty;

  /// Get display text for current selection
  String get selectedCountryDisplay {
    final country = selectedCountry.value;
    if (country == null) return 'Select Country';
    return '${country.flagEmoji} ${country.displayName}';
  }

  /// Check if NewsAPI supports this country
  bool isNewsApiSupported(String countryCode) {
    return _newsApiSupportedCountries.contains(countryCode.toLowerCase());
  }

  /// Get list of favorite countries (NewsAPI supported ones)
  List<Country> get favoriteCountries {
    return _newsApiSupportedCountries
        .map((code) {
          try {
            return Country.parse(code.toUpperCase());
          } catch (e) {
            return null;
          }
        })
        .where((country) => country != null)
        .cast<Country>()
        .toList();
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
