import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../services/news_service.dart';

/// Binding for the home/headlines feature
/// Manages dependencies specific to the headlines view
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure NewsService is available
    if (!Get.isRegistered<NewsService>()) {
      Get.lazyPut<NewsService>(() => NewsService(), fenix: true);
    }

    // Register HomeController
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
