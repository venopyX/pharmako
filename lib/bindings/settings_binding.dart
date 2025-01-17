import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

/// Binding for settings management
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
