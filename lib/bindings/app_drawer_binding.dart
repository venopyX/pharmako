import 'package:get/get.dart';
import '../controllers/app_drawer_controller.dart';

/// Binding for the App Drawer
/// Initializes and injects the AppDrawerController
class AppDrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppDrawerController>(
      () => AppDrawerController(),
      fenix: true,
    );
  }
}
