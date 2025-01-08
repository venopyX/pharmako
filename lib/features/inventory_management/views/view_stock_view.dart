import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/view_stock_controller.dart';
import '../../../common/widgets/inventory_data_table.dart';

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFilters(context),
                const SizedBox(height: AppSizes.padding),
                _buildStockTable(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Wrap(
          spacing: AppSizes.padding,
          runSpacing: AppSizes.padding,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Products',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: controller.searchProducts,
              ),
            ),
            SizedBox(
              width: 200,
              child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: controller.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => controller.updateFilters(category: value),
              )),
            ),
            SizedBox(
              width: 200,
              child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedManufacturer.value.isEmpty ? null : controller.selectedManufacturer.value,
                decoration: const InputDecoration(
                  labelText: 'Manufacturer',
                  border: OutlineInputBorder(),
                ),
                items: controller.manufacturers.map((manufacturer) {
                  return DropdownMenuItem(
                    value: manufacturer,
                    child: Text(manufacturer),
                  );
                }).toList(),
                onChanged: (value) => controller.updateFilters(manufacturer: value),
              )),
            ),
            Obx(() => FilterChip(
              label: const Text('Low Stock'),
              selected: controller.showLowStock.value,
              onSelected: (value) => controller.updateFilters(lowStock: value),
            )),
            Obx(() => FilterChip(
              label: const Text('Expiring Soon'),
              selected: controller.showExpiringSoon.value,
              onSelected: (value) => controller.updateFilters(expiringSoon: value),
            )),
            TextButton.icon(
              onPressed: () => _showDateRangePicker(context),
              icon: const Icon(Icons.date_range),
              label: Obx(() {
                final start = controller.expiryDateStart.value;
                final end = controller.expiryDateEnd.value;
                if (start != null && end != null) {
                  return Text(
                    '${controller.formatDate(start)} - ${controller.formatDate(end)}',
                    style: const TextStyle(fontSize: 14),
                  );
                }
                return const Text('Expiry Date Range');
              }),
            ),
            if (controller.expiryDateStart.value != null || 
                controller.expiryDateEnd.value != null ||
                controller.selectedCategory.value.isNotEmpty ||
                controller.selectedManufacturer.value.isNotEmpty ||
                controller.showLowStock.value ||
                controller.showExpiringSoon.value)
              TextButton.icon(
                onPressed: controller.clearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Filters'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final initialDateRange = controller.expiryDateStart.value != null && controller.expiryDateEnd.value != null
        ? DateTimeRange(
            start: controller.expiryDateStart.value!,
            end: controller.expiryDateEnd.value!,
          )
        : null;

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).primaryColor,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateFilters(
        startDate: picked.start,
        endDate: picked.end,
      );
    }
  }

  Widget _buildStockTable(BuildContext context) {
    return InventoryDataTable(
      title: 'Stock Items (${controller.totalProducts})',
      products: controller.paginatedProducts,
      formatDate: controller.formatDate,
      formatCurrency: controller.formatCurrency,
      onEdit: (id) => Get.toNamed('/edit-stock/$id'),
      onSort: controller.updateSort,
      rowsPerPage: controller.rowsPerPage.value,
      onRowsPerPageChanged: (value) => controller.updatePagination(null, value),
      totalRows: controller.totalProducts,
      onPageChanged: (page) => controller.updatePagination(page, null),
      currentPage: controller.currentPage.value,
      isLowStock: controller.isLowStock,
      isExpiringSoon: controller.isExpiringSoon,
      isExpired: controller.isExpired,
    );
  }
}
