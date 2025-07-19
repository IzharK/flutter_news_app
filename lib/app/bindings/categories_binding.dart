import 'package:get/get.dart';

import '../controllers/categories_controller.dart';
import '../services/news_service.dart';

/// Binding for the categories feature
/// Manages dependencies specific to the categories view
class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure NewsService is available
    if (!Get.isRegistered<NewsService>()) {
      Get.lazyPut<NewsService>(() => NewsService(), fenix: true);
    }

    // Register CategoriesController
    Get.lazyPut<CategoriesController>(
      () => CategoriesController(),
      fenix: true,
    );
  }
}
