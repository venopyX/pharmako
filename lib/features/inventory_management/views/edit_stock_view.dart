import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_stock_controller.dart';
import 'package:intl/intl.dart';

class EditStockView extends GetView<EditStockController> {
  const EditStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          TextButton.icon(
            onPressed: controller.saveProduct,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                label: 'Product Name',
                value: controller.name.value,
                onChanged: controller.updateName,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Description',
                value: controller.description.value,
                onChanged: controller.updateDescription,
                maxLines: 3,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Category',
                value: controller.category.value,
                items: controller.categories,
                onChanged: controller.updateCategory,
                required: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Price',
                      value: controller.price.value.toString(),
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
                      value: controller.quantity.value.toString(),
                      onChanged: controller.updateQuantity,
                      keyboardType: TextInputType.number,
                      required: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Unit',
                value: controller.unit.value,
                items: controller.units,
                onChanged: controller.updateUnit,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Manufacturer',
                value: controller.manufacturer.value,
                onChanged: controller.updateManufacturer,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildDateField(
                label: 'Expiry Date',
                value: controller.expiryDate.value,
                onChanged: controller.updateExpiryDate,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Minimum Stock Level',
                value: controller.minimumStockLevel.value.toString(),
                onChanged: controller.updateMinimumStockLevel,
                keyboardType: TextInputType.number,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Batch Number',
                value: controller.batchNumber.value,
                onChanged: controller.updateBatchNumber,
                required: true,
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Location',
                value: controller.location.value,
                items: controller.locations,
                onChanged: controller.updateLocation,
                required: true,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? prefixText,
    bool required = false,
  }) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    bool required = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime value,
    required Function(DateTime) onChanged,
    bool required = false,
  }) {
    return InkWell(
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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('MMM dd, yyyy').format(value)),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
