import 'package:get/get.dart';
import '../controllers/inventory_management_controller.dart';

/// Binding for inventory management
class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryManagementController>(
      () => InventoryManagementController(),
    );
  }
}
