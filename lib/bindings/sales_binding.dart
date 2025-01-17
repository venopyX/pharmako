import 'package:get/get.dart';
import '../controllers/sales_management_controller.dart';

/// Binding for sales management
class SalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesManagementController>(
      () => SalesManagementController(),
    );
  }
}
