import 'package:get/get.dart';
import '../controllers/notification_management_controller.dart';

/// Binding for notification management
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationManagementController>(
      () => NotificationManagementController(),
    );
  }
}
