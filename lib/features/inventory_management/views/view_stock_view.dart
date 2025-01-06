import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/view_stock_controller.dart';
import '../models/product_model.dart';

class ViewStockView extends GetView<ViewStockController> {
  const ViewStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/add-stock'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(context),
          _buildStockTable(),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(AppSizes.padding),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: controller.searchProducts,
                  ),
                ),
                const SizedBox(width: AppSizes.padding),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedCategory.value,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: controller.categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => controller.updateFilters(
                      category: value,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.padding),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedManufacturer.value,
                    decoration: const InputDecoration(
                      labelText: 'Manufacturer',
                      border: OutlineInputBorder(),
                    ),
                    items: controller.manufacturers
                        .map(
                          (manufacturer) => DropdownMenuItem(
                            value: manufacturer,
                            child: Text(manufacturer),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => controller.updateFilters(
                      manufacturer: value,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            Row(
              children: [
                Obx(
                  () => FilterChip(
                    selected: controller.showLowStock.value,
                    label: const Text('Low Stock'),
                    onSelected: (value) => controller.updateFilters(
                      lowStock: value,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Obx(
                  () => FilterChip(
                    selected: controller.showExpiringSoon.value,
                    label: const Text('Expiring Soon'),
                    onSelected: (value) => controller.updateFilters(
                      expiringSoon: value,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                TextButton.icon(
                  onPressed: () => _showDateRangePicker(context),
                  icon: const Icon(Icons.date_range),
                  label: Obx(
                    () => Text(
                      controller.expiryDateStart.value != null &&
                              controller.expiryDateEnd.value != null
                          ? '${controller.formatDate(controller.expiryDateStart.value!)} - '
                              '${controller.formatDate(controller.expiryDateEnd.value!)}'
                          : 'Select Date Range',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockTable() {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(AppSizes.padding),
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: const Text('Name'),
                          onSort: (_, __) => controller.updateSort('name'),
                        ),
                        DataColumn(
                          label: const Text('Category'),
                          onSort: (_, __) => controller.updateSort('category'),
                        ),
                        DataColumn(
                          label: const Text('Manufacturer'),
                          onSort: (_, __) =>
                              controller.updateSort('manufacturer'),
                        ),
                        DataColumn(
                          label: const Text('Quantity'),
                          numeric: true,
                          onSort: (_, __) => controller.updateSort('quantity'),
                        ),
                        DataColumn(
                          label: const Text('Price'),
                          numeric: true,
                          onSort: (_, __) => controller.updateSort('price'),
                        ),
                        DataColumn(
                          label: const Text('Total Value'),
                          numeric: true,
                          onSort: (_, __) =>
                              controller.updateSort('totalValue'),
                        ),
                        DataColumn(
                          label: const Text('Expiry Date'),
                          onSort: (_, __) =>
                              controller.updateSort('expiryDate'),
                        ),
                        const DataColumn(
                          label: Text('Actions'),
                        ),
                      ],
                      rows: controller.products
                          .map(
                            (product) => _buildProductRow(product),
                          )
                          .toList(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  DataRow _buildProductRow(Product product) {
    final isLowStock = product.quantity <= product.minimumStockLevel;
    final isExpiringSoon = product.isExpiringSoon;

    return DataRow(
      cells: [
        DataCell(Text(product.name)),
        DataCell(Text(product.category)),
        DataCell(Text(product.manufacturer)),
        DataCell(
          Text(
            controller.formatNumber(product.quantity),
            style: TextStyle(
              color: isLowStock ? AppColors.error : null,
              fontWeight: isLowStock ? FontWeight.bold : null,
            ),
          ),
        ),
        DataCell(Text(controller.formatCurrency(product.price))),
        DataCell(Text(controller.formatCurrency(product.totalValue))),
        DataCell(
          Text(
            controller.formatDate(product.expiryDate),
            style: TextStyle(
              color: isExpiringSoon ? AppColors.error : null,
              fontWeight: isExpiringSoon ? FontWeight.bold : null,
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => controller.editProduct(product.id),
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => controller.deleteProduct(product.id),
                tooltip: 'Delete',
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: controller.expiryDateStart.value ?? DateTime.now(),
      end: controller.expiryDateEnd.value ??
          DateTime.now().add(
            const Duration(days: 30),
          ),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: AppColors.onPrimary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      controller.updateFilters(
        startDate: pickedDateRange.start,
        endDate: pickedDateRange.end,
      );
    }
  }
}
