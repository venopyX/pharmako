import 'package:get/get.dart';
import '../features/sales_management/controllers/sales_controller.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/sales_repository.dart';

class SalesBinding extends Bindings {
  @override
  void dependencies() {
    // Register repositories if not already registered
    if (!Get.isRegistered<InventoryRepository>()) {
      Get.put(InventoryRepository());
    }
    if (!Get.isRegistered<SalesRepository>()) {
      Get.put(SalesRepository());
    }

    Get.lazyPut<SalesController>(
      () => SalesController(
        Get.find<InventoryRepository>(),
        Get.find<SalesRepository>(),
      ),
    );
  }
}
