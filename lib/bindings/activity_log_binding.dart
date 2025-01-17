import 'package:get/get.dart';
import '../controllers/activity_log_controller.dart';

/// Binding for the Activity Log feature
/// Initializes and injects the ActivityLogController
class ActivityLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityLogController>(
      () => ActivityLogController(),
      fenix: true,
    );
  }
}
