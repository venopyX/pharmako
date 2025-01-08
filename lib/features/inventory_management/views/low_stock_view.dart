import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/low_stock_alerts_controller.dart';
import '../models/low_stock_model.dart';

class LowStockView extends GetView<LowStockAlertsController> {
  const LowStockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Stock Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCards(),
                      const SizedBox(height: 24),
                      _buildLowStockList(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Critical Items',
              controller.criticalItems.length.toString(),
              Colors.red,
              Icons.warning_rounded,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'Needs Reorder',
              controller.needsReorderItems.length.toString(),
              Colors.orange,
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.lowStockItems.length,
        itemBuilder: (context, index) {
          final item = controller.lowStockItems[index];
          return _buildLowStockItem(item);
        },
      ),
    );
  }

  Widget _buildLowStockItem(LowStockItem item) {
    final stockLevelColor = item.isVeryLow ? Colors.red : Colors.orange;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: stockLevelColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item.stockLevel.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: stockLevelColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Category', item.category),
            _buildInfoRow('Current Stock', item.currentStock.toString()),
            _buildInfoRow('Minimum Threshold', item.minimumThreshold.toString()),
            _buildInfoRow('Supplier', item.supplier),
            _buildInfoRow(
              'Last Restocked',
              '${item.lastRestocked.year}-${item.lastRestocked.month.toString().padLeft(2, '0')}-${item.lastRestocked.day.toString().padLeft(2, '0')}',
            ),
            _buildInfoRow('Price', '\$${item.price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
