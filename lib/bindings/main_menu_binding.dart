import 'package:get/get.dart';
import '../controllers/main_menu_controller.dart';

/// Binding for the main menu screen
class MainMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainMenuController>(() => MainMenuController());
  }
}
