import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search Products',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: controller.searchProducts,
                  ),
                ),
                const SizedBox(width: AppSizes.padding),
                Obx(() => DropdownButton<String>(
                  value: controller.selectedCategory.value,
                  hint: const Text('Category'),
                  items: controller.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) => controller.updateFilters(category: value),
                )),
                const SizedBox(width: AppSizes.padding),
                Obx(() => DropdownButton<String>(
                  value: controller.selectedManufacturer.value,
                  hint: const Text('Manufacturer'),
                  items: controller.manufacturers.map((manufacturer) {
                    return DropdownMenuItem(
                      value: manufacturer,
                      child: Text(manufacturer),
                    );
                  }).toList(),
                  onChanged: (value) => controller.updateFilters(manufacturer: value),
                )),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            Row(
              children: [
                Obx(() => FilterChip(
                  label: const Text('Low Stock'),
                  selected: controller.showLowStock.value,
                  onSelected: (value) => controller.updateFilters(lowStock: value),
                )),
                const SizedBox(width: AppSizes.padding),
                Obx(() => FilterChip(
                  label: const Text('Expiring Soon'),
                  selected: controller.showExpiringSoon.value,
                  onSelected: (value) => controller.updateFilters(expiringSoon: value),
                )),
                const SizedBox(width: AppSizes.padding),
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
                    return const Text('Select Expiry Date Range');
                  }),
                ),
                const SizedBox(width: AppSizes.padding),
                if (controller.expiryDateStart.value != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => controller.updateFilters(
                      startDate: null,
                      endDate: null,
                    ),
                    tooltip: 'Clear date range',
                  ),
              ],
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
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => PaginatedDataTable(
              header: Text('Total Products: ${controller.totalProducts}'),
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
                  onSort: (_, __) => controller.updateSort('manufacturer'),
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
                  label: const Text('Expiry Date'),
                  onSort: (_, __) => controller.updateSort('expiryDate'),
                ),
                const DataColumn(label: Text('Actions')),
              ],
              source: _StockDataSource(
                controller.paginatedProducts,
                controller.formatDate,
                controller.formatCurrency,
                (id) => Get.toNamed('/edit-stock', arguments: id),
              ),
              rowsPerPage: controller.rowsPerPage.value,
              onRowsPerPageChanged: (value) => controller.updatePagination(null, value),
              showCheckboxColumn: false,
            )),
          ],
        ),
      ),
    );
  }
}

class _StockDataSource extends DataTableSource {
  final List<Product> products;
  final String Function(DateTime) formatDate;
  final String Function(double) formatCurrency;
  final Function(String) onEdit;

  _StockDataSource(this.products, this.formatDate, this.formatCurrency, this.onEdit);

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;
    final product = products[index];
    
    return DataRow(
      cells: [
        DataCell(Text(product.name)),
        DataCell(Text(product.category)),
        DataCell(Text(product.manufacturer)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${product.quantity} ${product.unit}'),
              if (product.isLowStock)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.warning, color: Colors.orange, size: 16),
                ),
            ],
          ),
        ),
        DataCell(Text(formatCurrency(product.price))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatDate(product.expiryDate)),
              if (product.isExpiringSoon)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.access_time, color: Colors.red, size: 16),
                ),
            ],
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(product.id),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
