import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_stock_controller.dart';

class AddStockView extends GetView<AddStockController> {
  const AddStockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              label: 'Product Name',
              onChanged: controller.updateName,
              required: true,
            ),
            _buildTextField(
              label: 'Description',
              onChanged: controller.updateDescription,
              maxLines: 3,
              required: true,
            ),
            _buildDropdownField(
              label: 'Category',
              value: controller.category.value,
              items: const ['Tablets', 'Syrups', 'Injections', 'Others'],
              onChanged: controller.updateCategory,
              required: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Price',
                    onChanged: controller.updatePrice,
                    keyboardType: TextInputType.number,
                    prefixText: '\$',
                    required: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Quantity',
                    onChanged: controller.updateQuantity,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
              ],
            ),
            _buildDropdownField(
              label: 'Unit',
              value: controller.unit.value,
              items: const ['Pieces', 'Boxes', 'Strips', 'Bottles'],
              onChanged: controller.updateUnit,
              required: true,
            ),
            _buildTextField(
              label: 'Manufacturer',
              onChanged: controller.updateManufacturer,
              required: true,
            ),
            _buildDateField(
              label: 'Expiry Date',
              value: controller.expiryDate.value,
              onChanged: controller.updateExpiryDate,
              required: true,
            ),
            _buildTextField(
              label: 'Minimum Stock Level',
              onChanged: controller.updateMinimumStockLevel,
              keyboardType: TextInputType.number,
              required: true,
            ),
            _buildTextField(
              label: 'Batch Number',
              onChanged: controller.updateBatchNumber,
              required: true,
            ),
            _buildTextField(
              label: 'Storage Location',
              onChanged: controller.updateLocation,
              required: true,
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: controller.isValid.value && !controller.isLoading.value
                  ? controller.addProduct
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixText: prefixText,
          filled: true,
          fillColor: Colors.grey[100],
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${value.day}/${value.month}/${value.year}',
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
