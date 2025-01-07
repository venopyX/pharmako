import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/add_stock_controller.dart';

class AddStockView extends GetView<AddStockController> {
  const AddStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              label: 'Product Name',
              onChanged: controller.updateName,
              required: true,
              errorText: controller.getError('name'),
            ),
            _buildTextField(
              label: 'Description',
              onChanged: controller.updateDescription,
              maxLines: 3,
              required: true,
              errorText: controller.getError('description'),
            ),
            Obx(() => _buildDropdownField(
              label: 'Category',
              value: controller.category.value,
              items: controller.categories,
              onChanged: controller.updateCategory,
              required: true,
              errorText: controller.getError('category'),
            )),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Price',
                    onChanged: controller.updatePrice,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixText: '\$',
                    required: true,
                    errorText: controller.getError('price'),
                  ),
                ),
                const SizedBox(width: AppSizes.padding),
                Expanded(
                  child: _buildTextField(
                    label: 'Quantity',
                    onChanged: controller.updateQuantity,
                    keyboardType: TextInputType.number,
                    required: true,
                    errorText: controller.getError('quantity'),
                  ),
                ),
              ],
            ),
            Obx(() => _buildDropdownField(
              label: 'Unit',
              value: controller.unit.value,
              items: controller.units,
              onChanged: controller.updateUnit,
              required: true,
              errorText: controller.getError('unit'),
            )),
            Obx(() => _buildDropdownField(
              label: 'Manufacturer',
              value: controller.manufacturer.value,
              items: controller.manufacturers,
              onChanged: controller.updateManufacturer,
              required: true,
              errorText: controller.getError('manufacturer'),
            )),
            _buildDateField(
              label: 'Expiry Date',
              value: controller.expiryDate.value,
              onChanged: controller.updateExpiryDate,
              required: true,
              errorText: controller.getError('expiryDate'),
            ),
            _buildTextField(
              label: 'Minimum Stock Level',
              onChanged: controller.updateMinimumStockLevel,
              keyboardType: TextInputType.number,
              required: true,
              errorText: controller.getError('minimumStockLevel'),
            ),
            _buildTextField(
              label: 'Batch Number',
              onChanged: controller.updateBatchNumber,
              required: true,
              errorText: controller.getError('batchNumber'),
            ),
            Obx(() => _buildDropdownField(
              label: 'Storage Location',
              value: controller.location.value,
              items: controller.locations,
              onChanged: controller.updateLocation,
              required: true,
              errorText: controller.getError('location'),
            )),
            const SizedBox(height: AppSizes.padding * 2),
            Obx(() => ElevatedButton(
              onPressed: controller.isValid.value && !controller.isLoading.value
                  ? controller.addProduct
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(AppSizes.padding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Add Product',
                      style: TextStyle(fontSize: 16),
                    ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? prefixText,
    bool required = false,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.padding),
      child: TextField(
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixText: prefixText,
          filled: true,
          fillColor: Colors.grey[100],
          errorText: errorText,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    bool required = false,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.padding),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          errorText: errorText,
        ),
        value: value.isEmpty ? null : value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime value,
    required Function(DateTime) onChanged,
    bool required = false,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.padding),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: Get.context!,
            initialDate: value,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 3650)),
          );
          if (date != null) {
            onChanged(date);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : ''),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            errorText: errorText,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.formatDate(value),
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }
}
