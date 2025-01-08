import 'package:get/get.dart';
import '../data/repositories/alert_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/services/alert_service.dart';
import '../data/services/inventory_service.dart';
import '../features/home_dashboard/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize repositories if not already initialized
    if (!Get.isRegistered<AlertRepository>()) {
      Get.put(AlertRepository());
    }
    if (!Get.isRegistered<InventoryRepository>()) {
      Get.put(InventoryRepository());
    }

    // Initialize services if not already initialized
    if (!Get.isRegistered<AlertService>()) {
      Get.put(AlertService(Get.find<AlertRepository>()));
    }
    if (!Get.isRegistered<InventoryService>()) {
      Get.put(InventoryService(Get.find<InventoryRepository>()));
    }

    // Initialize the dashboard controller with required services
    Get.put(DashboardController(
      Get.find<InventoryService>(),
      Get.find<AlertService>(),
    ));
  }
}
