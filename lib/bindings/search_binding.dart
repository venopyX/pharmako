import 'package:get/get.dart';
import '../controllers/search_controller.dart';

/// Binding for search functionality
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
  }
}
