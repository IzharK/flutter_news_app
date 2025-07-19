import 'package:get/get.dart';

import '../models/news_article.dart';
import '../services/news_service.dart';

class HomeController extends GetxController {
  final NewsService _newsService = Get.find();

  /// Holds the current index of the bottom navigation bar.
  final RxInt currentIndex = 0.obs;

  /// Reactive list of top headline articles.
  final RxList<NewsArticle> articles = <NewsArticle>[].obs;

  /// Manages loading state for the headlines view.
  final RxBool isLoading = true.obs;

  /// Holds any error message that occurs during fetch.
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }

  /// Fetches top headlines from the NewsService.
  Future<void> fetchTopHeadlines({String country = 'us'}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _newsService.getTopHeadlines(country: country);
      final articlesData = response['articles'] as List? ?? [];
      articles.value = articlesData
          .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) => currentIndex.value = index;
}
