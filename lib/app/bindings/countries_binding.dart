import 'package:get/get.dart';

import '../controllers/countries_controller.dart';
import '../services/news_service.dart';

/// Binding for the countries feature
/// Manages dependencies specific to the countries view
class CountriesBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure NewsService is available
    if (!Get.isRegistered<NewsService>()) {
      Get.lazyPut<NewsService>(() => NewsService(), fenix: true);
    }

    // Register CountriesController
    Get.lazyPut<CountriesController>(() => CountriesController(), fenix: true);
  }
}
