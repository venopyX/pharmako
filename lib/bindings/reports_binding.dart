import 'package:get/get.dart';
import 'package:pharmako/controllers/reports_management_controller.dart';

/// Binding for the Reports Management feature
/// Initializes and injects the ReportsManagementController
class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsManagementController>(
      () => ReportsManagementController(),
      fenix: true,
    );
  }
}
