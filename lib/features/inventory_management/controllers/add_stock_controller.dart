// TODO: Implement controller logic for adding stock items.

import 'package:get/get.dart';
import '../../../data/services/inventory_service.dart';

class AddStockController extends GetxController {
  final InventoryService _inventoryService;
  final RxBool isLoading = false.obs;

  // Form fields
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxString category = ''.obs;
  final RxDouble price = 0.0.obs;
  final RxInt quantity = 0.obs;
  final RxString unit = ''.obs;
  final RxString manufacturer = ''.obs;
  final Rx<DateTime> expiryDate = DateTime.now().obs;
  final RxInt minimumStockLevel = 0.obs;
  final RxString batchNumber = ''.obs;
  final RxString location = ''.obs;

  // Form validation
  final RxBool isValid = false.obs;

  AddStockController(this._inventoryService);

  void updateName(String value) {
    name.value = value;
    validateForm();
  }

  void updateDescription(String value) {
    description.value = value;
    validateForm();
  }

  void updateCategory(String? value) {
    if (value != null) {
      category.value = value;
      validateForm();
    }
  }

  void updatePrice(String value) {
    try {
      price.value = double.parse(value);
    } catch (_) {
      price.value = 0.0;
    }
    validateForm();
  }

  void updateQuantity(String value) {
    try {
      quantity.value = int.parse(value);
    } catch (_) {
      quantity.value = 0;
    }
    validateForm();
  }

  void updateUnit(String? value) {
    if (value != null) {
      unit.value = value;
      validateForm();
    }
  }

  void updateManufacturer(String value) {
    manufacturer.value = value;
    validateForm();
  }

  void updateExpiryDate(DateTime value) {
    expiryDate.value = value;
    validateForm();
  }

  void updateMinimumStockLevel(String value) {
    try {
      minimumStockLevel.value = int.parse(value);
    } catch (_) {
      minimumStockLevel.value = 0;
    }
    validateForm();
  }

  void updateBatchNumber(String value) {
    batchNumber.value = value;
    validateForm();
  }

  void updateLocation(String value) {
    location.value = value;
    validateForm();
  }

  void validateForm() {
    isValid.value = name.value.isNotEmpty &&
        description.value.isNotEmpty &&
        category.value.isNotEmpty &&
        price.value > 0 &&
        quantity.value >= 0 &&
        unit.value.isNotEmpty &&
        manufacturer.value.isNotEmpty &&
        expiryDate.value.isAfter(DateTime.now()) &&
        minimumStockLevel.value >= 0 &&
        batchNumber.value.isNotEmpty &&
        location.value.isNotEmpty;
  }

  Future<void> addProduct() async {
    if (!isValid.value) return;

    isLoading.value = true;
    try {
      await _inventoryService.addProduct(
        name: name.value,
        description: description.value,
        category: category.value,
        price: price.value,
        quantity: quantity.value,
        unit: unit.value,
        manufacturer: manufacturer.value,
        expiryDate: expiryDate.value,
        minimumStockLevel: minimumStockLevel.value,
        batchNumber: batchNumber.value,
        location: location.value,
      );

      Get.snackbar(
        'Success',
        'Product added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    name.value = '';
    description.value = '';
    category.value = '';
    price.value = 0.0;
    quantity.value = 0;
    unit.value = '';
    manufacturer.value = '';
    expiryDate.value = DateTime.now();
    minimumStockLevel.value = 0;
    batchNumber.value = '';
    location.value = '';
    isValid.value = false;
  }
}
