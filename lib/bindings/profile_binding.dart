import 'package:get/get.dart';
import '../controllers/user_profile_management_controller.dart';

/// Binding for profile management
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileManagementController>(
      () => UserProfileManagementController(),
    );
  }
}
