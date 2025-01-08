import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshDashboard,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Get.toNamed('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildSummaryCards(context),
              const SizedBox(height: 24),
              _buildSalesChart(),
              const SizedBox(height: 24),
              _buildRecentAlerts(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/add-stock'),
        icon: const Icon(Icons.add),
        label: const Text('Add Stock'),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionButton(
          'View Stock',
          Icons.inventory_2,
          () => Get.toNamed('/inventory'),
        ),
        _buildActionButton(
          'New Sale',
          Icons.point_of_sale,
          () => Get.toNamed('/sale'),
        ),
        _buildActionButton(
          'Reports',
          Icons.bar_chart,
          () => Get.toNamed('/reports'),
        ),
        _buildActionButton(
          'Low Stock',
          Icons.warning_amber,
          () => Get.toNamed('/low-stock'),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 
                             constraints.maxWidth < 900 ? 3 : 4;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.8,
          padding: EdgeInsets.zero,
          children: [
            _buildSummaryCard(
              'Total Products',
              controller.summary.value.totalProducts.toString(),
              Icons.inventory,
              Colors.blue,
              () => Get.toNamed('/inventory'),
            ),
            _buildSummaryCard(
              'Low Stock Items',
              controller.summary.value.lowStockItems.toString(),
              Icons.warning,
              Colors.orange,
              () => Get.toNamed('/low-stock'),
            ),
            _buildSummaryCard(
              'Expiring Items',
              controller.summary.value.expiringItems.toString(),
              Icons.timer,
              Colors.red,
              () => Get.toNamed('/expiring'),
            ),
            _buildSummaryCard(
              'Total Sales',
              '\$${controller.summary.value.totalSales.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.green,
              () => Get.toNamed('/sales'),
            ),
            _buildSummaryCard(
              'Pending Alerts',
              controller.summary.value.pendingAlerts.toString(),
              Icons.notifications,
              Colors.purple,
              () => Get.toNamed('/alerts'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Get.textTheme.headlineMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Sales',
                  style: Get.textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () => Get.toNamed('/reports'),
                  icon: const Icon(Icons.analytics),
                  label: const Text('View Reports'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: controller.salesData.map((data) => data.value).reduce((a, b) => a > b ? a : b) * 1.2,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= controller.salesData.length) return const Text('');
                          return Text(controller.salesData[value.toInt()].label);
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: controller.salesData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value,
                          color: Get.theme.primaryColor,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAlerts() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Alerts',
                  style: Get.textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () => Get.toNamed('/notifications'),
                  icon: const Icon(Icons.notifications),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentAlerts.length,
              itemBuilder: (context, index) {
                final alert = controller.recentAlerts[index];
                return ListTile(
                  leading: Icon(
                    alert.icon,
                    color: alert.color,
                  ),
                  title: Text(alert.title),
                  subtitle: Text(alert.message),
                  trailing: Text(
                    controller.getTimeAgo(alert.timestamp),
                    style: Get.textTheme.bodySmall,
                  ),
                  onTap: () => Get.toNamed('/notifications'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}