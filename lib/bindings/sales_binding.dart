import 'package:get/get.dart';
import '../features/sales_management/controllers/sales_controller.dart';
import '../data/repositories/inventory_repository.dart';

class SalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesController>(
      () => SalesController(Get.find<InventoryRepository>()),
    );
  }
}
