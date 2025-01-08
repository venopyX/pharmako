import 'package:get/get.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/services/inventory_service.dart';
import '../features/inventory_management/controllers/expiring_items_controller.dart';

class ExpiringItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryRepository>(
      () => InventoryRepository(),
    );

    Get.lazyPut<InventoryService>(
      () => InventoryService(Get.find<InventoryRepository>()),
    );

    Get.lazyPut<ExpiringItemsController>(
      () => ExpiringItemsController(Get.find<InventoryService>()),
    );
  }
}
