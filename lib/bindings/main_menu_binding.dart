import 'package:get/get.dart';
import '../features/main_menu/controllers/main_menu_controller.dart';

class MainMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainMenuController>(
      () => MainMenuController(),
    );
  }
}
