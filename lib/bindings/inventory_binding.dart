import 'package:get/get.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/services/inventory_service.dart';
import '../features/inventory_management/controllers/add_stock_controller.dart';
import '../features/inventory_management/controllers/edit_stock_controller.dart';
import '../features/inventory_management/controllers/view_stock_controller.dart';

class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<InventoryRepository>(
      () => InventoryRepository(),
    );

    // Service
    Get.lazyPut<InventoryService>(
      () => InventoryService(Get.find<InventoryRepository>()),
    );

    // Controllers
    Get.lazyPut<ViewStockController>(
      () => ViewStockController(Get.find<InventoryService>()),
    );

    Get.lazyPut<AddStockController>(
      () => AddStockController(Get.find<InventoryService>()),
    );

    Get.lazyPut<EditStockController>(
      () => EditStockController(
        Get.find<InventoryService>(),
        Get.arguments as String,
      ),
      fenix: true,
    );
  }
}
