import 'package:get/get.dart';
import '../data/repositories/alert_repository.dart';
import '../data/services/alert_service.dart';
import '../features/alerts_and_notifications/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<AlertRepository>(
      () => AlertRepository(),
    );

    // Service
    Get.lazyPut<AlertService>(
      () => AlertService(Get.find<AlertRepository>()),
    );

    // Controller
    Get.lazyPut<NotificationController>(
      () => NotificationController(Get.find<AlertService>()),
    );
  }
}
