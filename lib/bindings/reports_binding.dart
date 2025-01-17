import 'package:get/get.dart';
import 'package:pharmako/controllers/reports_controller.dart';

/// Binding for the Reports Management feature
/// Initializes and injects the ReportsController
class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsController>(
      () => ReportsController(),
      fenix: true,
    );
  }
}
