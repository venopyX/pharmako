import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expiring_items_controller.dart';

class ExpiringItemsView extends GetView<ExpiringItemsController> {
  const ExpiringItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiring Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildFilters(context),
            _buildSummaryCards(),
            Expanded(
              child: _buildExpiringTable(context),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
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
          const SizedBox(width: 16),
          Obx(() => DropdownButton<String>(
            value: controller.selectedCategory.value,
            items: controller.categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: controller.updateCategory,
          )),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Expired',
              controller.expiredItems.length.toString(),
              Colors.red,
              Icons.error,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'Critical',
              controller.criticalItems.length.toString(),
              Colors.orange,
              Icons.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'Warning',
              controller.warningItems.length.toString(),
              Colors.amber,
              Icons.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringTable(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PaginatedDataTable(
          header: const Text('Expiring Items'),
          rowsPerPage: controller.rowsPerPage.value,
          availableRowsPerPage: const [10, 25, 50],
          onRowsPerPageChanged: controller.updatePagination,
          columns: [
            DataColumn(
              label: const Text('Status'),
              onSort: (_, __) => controller.updateSort('status'),
            ),
            DataColumn(
              label: const Text('Name'),
              onSort: (_, __) => controller.updateSort('name'),
            ),
            DataColumn(
              label: const Text('Category'),
              onSort: (_, __) => controller.updateSort('category'),
            ),
            DataColumn(
              label: const Text('Expiry Date'),
              onSort: (_, __) => controller.updateSort('expiryDate'),
            ),
            DataColumn(
              label: const Text('Days to Expiry'),
              onSort: (_, __) => controller.updateSort('daysToExpiry'),
            ),
            const DataColumn(label: Text('Price')),
            const DataColumn(label: Text('Actions')),
          ],
          source: _ExpiringItemsDataSource(
            controller.paginatedProducts,
            controller,
            onEdit: (id) => Get.toNamed('/edit-stock', arguments: id),
          ),
        ),
      ),
    );
  }
}

class _ExpiringItemsDataSource extends DataTableSource {
  final List<dynamic> _products;
  final ExpiringItemsController _controller;
  final Function(String) onEdit;

  _ExpiringItemsDataSource(this._products, this._controller, {required this.onEdit});

  @override
  DataRow getRow(int index) {
    final product = _products[index];
    final daysToExpiry = _controller.getDaysToExpiry(product.expiryDate);
    final status = _controller.getExpiryStatus(product);
    final statusColor = _controller.getExpiryStatusColor(product);
    final statusIcon = _controller.getExpiryStatusIcon(product);

    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 4),
              Text(status, style: TextStyle(color: statusColor)),
            ],
          ),
        ),
        DataCell(Text(product.name)),
        DataCell(Text(product.category)),
        DataCell(Text(_controller.formatDate(product.expiryDate))),
        DataCell(Text(
          daysToExpiry < 0
              ? '${-daysToExpiry} days ago'
              : daysToExpiry == 0
                  ? 'Today'
                  : '$daysToExpiry days',
          style: TextStyle(color: statusColor),
        )),
        DataCell(Text(_controller.formatCurrency(product.price))),
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
  int get rowCount => _products.length;

  @override
  int get selectedRowCount => 0;
}
