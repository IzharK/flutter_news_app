import 'package:get/get.dart';

import '../controllers/categories_controller.dart';
import '../controllers/countries_controller.dart';
import '../controllers/home_controller.dart';
import '../services/news_service.dart';

/// Initial binding for core app dependencies
/// Registers essential services and controllers with proper lifecycle management
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services - registered with fenix: true for automatic recreation
    Get.lazyPut<NewsService>(() => NewsService(), fenix: true);

    // Core controllers - HomeController is needed for navigation state
    Get.put<HomeController>(HomeController());

    // Feature controllers - initialized immediately to avoid GetX errors
    Get.put<CountriesController>(CountriesController());
    Get.put<CategoriesController>(CategoriesController());
  }
}
