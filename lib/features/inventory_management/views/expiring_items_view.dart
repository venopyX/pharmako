import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';
import '../../../common/widgets/inventory_data_table.dart';
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
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/add-stock'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
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
                _buildSummaryCards(),
                const SizedBox(height: AppSizes.padding),
                _buildExpiringTable(context),
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
                items: [
                  const DropdownMenuItem(value: '', child: Text('All Categories')),
                  ...controller.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }),
                ],
                onChanged: controller.updateCategory,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Wrap(
      spacing: AppSizes.padding,
      runSpacing: AppSizes.padding,
      children: [
        _buildSummaryCard(
          'Expired Items',
          controller.expiredItems.length.toString(),
          Colors.red,
          Icons.error_outline,
        ),
        _buildSummaryCard(
          'Critical (≤30 days)',
          controller.criticalItems.length.toString(),
          Colors.orange,
          Icons.warning_rounded,
        ),
        _buildSummaryCard(
          'Warning (≤90 days)',
          controller.warningItems.length.toString(),
          Colors.amber,
          Icons.watch_later_outlined,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringTable(BuildContext context) {
    return InventoryDataTable(
      title: 'Expiring Items',
      products: controller.paginatedProducts,
      totalRows: controller.totalProducts,
      formatDate: controller.formatDate,
      formatCurrency: controller.formatCurrency,
      onEdit: (id) => Get.toNamed('/edit-stock', arguments: id),
      onSort: controller.updateSort,
      rowsPerPage: controller.rowsPerPage.value,
      onRowsPerPageChanged: (value) => controller.updatePagination(value),
      onPageChanged: controller.onPageChanged,
      currentPage: controller.currentPage.value,
      isLowStock: (product) => product.quantity <= product.minimumStockLevel,
      isExpiringSoon: (product) {
        final now = DateTime(2025, 1, 8);
        final thirtyDaysFromNow = now.add(const Duration(days: 30));
        return product.expiryDate.isBefore(thirtyDaysFromNow) && product.expiryDate.isAfter(now);
      },
      isExpired: (product) => product.expiryDate.isBefore(DateTime(2025, 1, 8)),
    );
  }
}
