import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/inventory_service.dart';
import '../../../data/repositories/reference_data_repository.dart';
import '../../../utils/logging/logger.dart';
import '../models/product_model.dart';

class AddStockController extends GetxController {
  final InventoryService _inventoryService;
  final ReferenceDataRepository _referenceDataRepository;
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
  final RxMap<String, String> errors = <String, String>{}.obs;

  // Predefined lists
  final RxList<String> categories = <String>[].obs;
  final RxList<String> units = <String>[].obs;
  final RxList<String> manufacturers = <String>[].obs;
  final RxList<String> locations = <String>[].obs;

  AddStockController(this._inventoryService) 
      : _referenceDataRepository = ReferenceDataRepository();

  @override
  void onInit() {
    super.onInit();
    final product = Get.arguments as Product?;
    if (product != null) {
      // Editing existing product
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
    }
    loadReferenceData();
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

  void updateName(String value) {
    name.value = value;
    validateField('name', value);
    validateForm();
  }

  void updateDescription(String value) {
    description.value = value;
    validateField('description', value);
    validateForm();
  }

  void updateCategory(String? value) {
    if (value != null) {
      category.value = value;
      validateField('category', value);
      validateForm();
    }
  }

  void updatePrice(String value) {
    try {
      final newPrice = double.parse(value);
      if (newPrice >= 0) {
        price.value = newPrice;
        errors.remove('price');
      } else {
        errors['price'] = 'Price must be positive';
      }
    } catch (_) {
      errors['price'] = 'Invalid price format';
      price.value = 0.0;
    }
    validateForm();
  }

  void updateQuantity(String value) {
    try {
      final newQuantity = int.parse(value);
      if (newQuantity >= 0) {
        quantity.value = newQuantity;
        errors.remove('quantity');
      } else {
        errors['quantity'] = 'Quantity must be positive';
      }
    } catch (_) {
      errors['quantity'] = 'Invalid quantity format';
      quantity.value = 0;
    }
    validateForm();
  }

  void updateUnit(String? value) {
    if (value != null) {
      unit.value = value;
      validateField('unit', value);
      validateForm();
    }
  }

  void updateManufacturer(String? value) {
    if (value != null) {
      manufacturer.value = value;
      validateField('manufacturer', value);
      validateForm();
    }
  }

  void updateExpiryDate(DateTime value) {
    if (value.isAfter(DateTime.now())) {
      expiryDate.value = value;
      errors.remove('expiryDate');
    } else {
      errors['expiryDate'] = 'Expiry date must be in the future';
    }
    validateForm();
  }

  void updateMinimumStockLevel(String value) {
    try {
      final newLevel = int.parse(value);
      if (newLevel >= 0) {
        minimumStockLevel.value = newLevel;
        errors.remove('minimumStockLevel');
      } else {
        errors['minimumStockLevel'] = 'Minimum stock level must be positive';
      }
    } catch (_) {
      errors['minimumStockLevel'] = 'Invalid format';
      minimumStockLevel.value = 0;
    }
    validateForm();
  }

  void updateBatchNumber(String value) {
    batchNumber.value = value;
    validateField('batchNumber', value);
    validateForm();
  }

  void updateLocation(String? value) {
    if (value != null) {
      location.value = value;
      validateField('location', value);
      validateForm();
    }
  }

  void validateField(String field, String value) {
    if (value.isEmpty) {
      errors[field] = '$field is required';
    } else {
      errors.remove(field);
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
        expiryDate.value.isAfter(DateTime.now()) &&
        minimumStockLevel.value >= 0 &&
        batchNumber.value.isNotEmpty &&
        location.value.isNotEmpty &&
        errors.isEmpty;
  }

  Future<void> addProduct() async {
    if (!isValid.value) return;

    isLoading.value = true;
    try {
      final product = Get.arguments as Product?;
      final Map<String, dynamic> productData = {
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

      if (product != null) {
        // Update existing product
        await _inventoryService.updateProduct(product.id, productData);
      } else {
        // Add new product
        await _inventoryService.addProduct(productData);
      }

      Get.back(result: true);
      Get.snackbar(
        'Success',
        product != null ? 'Product updated successfully' : 'Product added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      AppLogger.error('Failed to ${Get.arguments != null ? 'update' : 'add'} product: $e');
      Get.snackbar(
        'Error',
        'Failed to ${Get.arguments != null ? 'update' : 'add'} product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? getError(String field) {
    return errors[field];
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
    errors.clear();
    isValid.value = false;
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
