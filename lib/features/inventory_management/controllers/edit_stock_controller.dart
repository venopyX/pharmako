import 'package:get/get.dart';
import '../../../data/services/inventory_service.dart';
import '../../../data/repositories/reference_data_repository.dart';

class EditStockController extends GetxController {
  final InventoryService _inventoryService;
  final ReferenceDataRepository _referenceDataRepository;
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

  // Dropdown options
  final RxList<String> categories = <String>[].obs;
  final RxList<String> units = <String>[].obs;
  final RxList<String> locations = <String>[].obs;
  final RxList<String> manufacturers = <String>[].obs;

  // Form validation
  final RxBool isValid = false.obs;
  final RxBool isLoading = false.obs;

  EditStockController(this._inventoryService, this.productId) 
      : _referenceDataRepository = ReferenceDataRepository();

  @override
  void onInit() {
    super.onInit();
    loadReferenceData();
    loadProduct();
  }

  Future<void> loadReferenceData() async {
    try {
      categories.value = await _referenceDataRepository.getCategories();
      units.value = await _referenceDataRepository.getUnits();
      locations.value = await _referenceDataRepository.getLocations();
      manufacturers.value = await _referenceDataRepository.getManufacturers();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load reference data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
        // Convert internal location name to display name
        location.value = _referenceDataRepository.getLocationDisplayName(product.location) ?? product.location;
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

  void updateLocation(String? value) {
    if (value != null) {
      location.value = value;
      validateForm();
    }
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
    if (!isValid.value) return;

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
        'location': _referenceDataRepository.getLocationInternalName(location.value) ?? location.value,
      };

      await _inventoryService.updateProduct(productId, productData);
      Get.back();
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
