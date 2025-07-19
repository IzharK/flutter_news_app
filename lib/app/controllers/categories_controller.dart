import 'package:get/get.dart';

import '../models/news_article.dart';
import '../services/news_service.dart';

/// Controller for managing news categories and search functionality
/// Handles category selection, search queries, and state management
class CategoriesController extends GetxController {
  final NewsService _newsService = Get.find();

  /// List of supported news categories
  final RxList<String> categories = NewsService.getSupportedCategories().obs;

  /// Currently selected category
  final RxString selectedCategory = 'general'.obs;

  /// Search query string
  final RxString searchQuery = ''.obs;

  /// Reactive list of news articles for the selected category/search
  final RxList<NewsArticle> articles = <NewsArticle>[].obs;

  /// Manages loading state
  final RxBool isLoading = false.obs;

  /// Holds any error message that occurs during fetch
  final RxString errorMessage = ''.obs;

  /// Tracks if initial data has been loaded
  final RxBool hasInitialData = false.obs;

  /// Tracks current mode: 'category' or 'search'
  final RxString currentMode = 'category'.obs;

  /// Search results count
  final RxInt searchResultsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultCategory();
  }

  /// Initialize with the general category as default
  void _initializeDefaultCategory() {
    fetchNewsByCategory(selectedCategory.value);
  }

  /// Select a category and fetch its news
  /// [category] - News category string
  Future<void> selectCategory(String category) async {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      currentMode.value = 'category';
      searchQuery.value = '';
      await fetchNewsByCategory(category);
    }
  }

  /// Fetch news articles for a specific category
  /// [category] - News category string
  Future<void> fetchNewsByCategory(String category) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _newsService.getNewsByCategory(
        category: category,
        pageSize: 50,
      );
      
      final articlesData = response['articles'] as List? ?? [];
      articles.value = articlesData
          .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
          .toList();
      
      hasInitialData.value = true;
      searchResultsCount.value = articles.length;
    } catch (e) {
      errorMessage.value = e.toString();
      // Don't clear articles on error to maintain previous data
    } finally {
      isLoading.value = false;
    }
  }

  /// Search for news articles with a query
  /// [query] - Search query string
  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      // If query is empty, return to category mode
      currentMode.value = 'category';
      await fetchNewsByCategory(selectedCategory.value);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentMode.value = 'search';
      searchQuery.value = query;
      
      final response = await _newsService.searchNews(
        query: query,
        pageSize: 50,
        sortBy: 'publishedAt',
      );
      
      final articlesData = response['articles'] as List? ?? [];
      articles.value = articlesData
          .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
          .toList();
      
      hasInitialData.value = true;
      searchResultsCount.value = articles.length;
    } catch (e) {
      errorMessage.value = e.toString();
      // Don't clear articles on error to maintain previous data
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear search and return to category mode
  void clearSearch() {
    searchQuery.value = '';
    currentMode.value = 'category';
    fetchNewsByCategory(selectedCategory.value);
  }

  /// Refresh current content (category or search)
  Future<void> refreshContent() async {
    if (currentMode.value == 'search' && searchQuery.value.isNotEmpty) {
      await searchNews(searchQuery.value);
    } else {
      await fetchNewsByCategory(selectedCategory.value);
    }
  }

  /// Get category display name with proper formatting
  String getCategoryDisplayName(String category) {
    switch (category) {
      case 'general':
        return 'General';
      case 'business':
        return 'Business';
      case 'entertainment':
        return 'Entertainment';
      case 'health':
        return 'Health';
      case 'science':
        return 'Science';
      case 'sports':
        return 'Sports';
      case 'technology':
        return 'Technology';
      default:
        return category.toUpperCase();
    }
  }

  /// Get category icon
  String getCategoryIcon(String category) {
    switch (category) {
      case 'general':
        return '📰';
      case 'business':
        return '💼';
      case 'entertainment':
        return '🎬';
      case 'health':
        return '🏥';
      case 'science':
        return '🔬';
      case 'sports':
        return '⚽';
      case 'technology':
        return '💻';
      default:
        return '📄';
    }
  }

  /// Check if a category is currently selected
  bool isCategorySelected(String category) {
    return selectedCategory.value == category && currentMode.value == 'category';
  }

  /// Get total number of articles
  int get totalArticles => articles.length;

  /// Check if there are any articles to display
  bool get hasArticles => articles.isNotEmpty;

  /// Get current display title
  String get currentDisplayTitle {
    if (currentMode.value == 'search' && searchQuery.value.isNotEmpty) {
      return 'Search: "${searchQuery.value}"';
    }
    return getCategoryDisplayName(selectedCategory.value);
  }

  /// Get current subtitle with article count
  String get currentSubtitle {
    if (currentMode.value == 'search') {
      return '$searchResultsCount search results';
    }
    return '$totalArticles articles in ${getCategoryDisplayName(selectedCategory.value).toLowerCase()}';
  }

  /// Check if currently in search mode
  bool get isSearchMode => currentMode.value == 'search';

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
