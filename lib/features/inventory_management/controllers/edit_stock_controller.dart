import 'package:get/get.dart';
import '../../../data/services/inventory_service.dart';

class EditStockController extends GetxController {
  final InventoryService _inventoryService;
  final String productId;

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
  final RxBool isLoading = false.obs;

  EditStockController(this._inventoryService, this.productId);

  @override
  void onInit() {
    super.onInit();
    loadProduct();
  }

  Future<void> loadProduct() async {
    isLoading.value = true;
    try {
      final product = await _inventoryService.getProductById(productId);
      if (product != null) {
        name.value = product.name;
        description.value = product.description;
        category.value = product.category;
        price.value = product.price;
        quantity.value = product.quantity;
        unit.value = product.unit;
        manufacturer.value = product.manufacturer;
        expiryDate.value = product.expiryDate;
        minimumStockLevel.value = product.minimumStockLevel;
        batchNumber.value = product.batchNumber;
        location.value = product.location;
        validateForm();
      } else {
        Get.back();
        Get.snackbar(
          'Error',
          'Product not found',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

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
        minimumStockLevel.value >= 0 &&
        batchNumber.value.isNotEmpty &&
        location.value.isNotEmpty;
  }

  Future<void> saveProduct() async {
    if (!isValid.value) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final productData = {
        'name': name.value,
        'description': description.value,
        'category': category.value,
        'price': price.value,
        'quantity': quantity.value,
        'unit': unit.value,
        'manufacturer': manufacturer.value,
        'expiryDate': expiryDate.value,
        'minimumStockLevel': minimumStockLevel.value,
        'batchNumber': batchNumber.value,
        'location': location.value,
      };

      await _inventoryService.updateProduct(productId, productData);
      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
