// TODO: Implement controller logic for the main menu navigation.

import 'package:get/get.dart';

class MainMenuController extends GetxController {
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    try {
      // Load any necessary initial data
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load initial data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
