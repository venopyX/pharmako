import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/inventory_analytics_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class InventoryAnalyticsView extends GetView<InventoryAnalyticsController> {
  const InventoryAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: controller.exportReport,
            tooltip: 'Export Report',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(),
                    const SizedBox(height: AppSizes.padding),
                    _buildInventoryValueTrendCard(),
                    const SizedBox(height: AppSizes.padding),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildCategoryDistributionCard()),
                        const SizedBox(width: AppSizes.padding),
                        Expanded(child: _buildLowStockItemsCard()),
                      ],
                    ),
                    const SizedBox(height: AppSizes.padding),
                    _buildExpiringItemsCard(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: AppSizes.padding,
      crossAxisSpacing: AppSizes.padding,
      children: [
        _buildSummaryCard(
          'Total Products',
          controller.formatNumber(controller.analytics.value.totalProducts),
          Icons.inventory_2,
          AppColors.primary,
          'Active items',
        ),
        _buildSummaryCard(
          'Inventory Value',
          controller.formatCurrency(controller.analytics.value.inventoryValue),
          Icons.attach_money,
          AppColors.success,
          'Total value',
        ),
        _buildSummaryCard(
          'Low Stock',
          controller.formatNumber(controller.analytics.value.lowStockCount),
          Icons.warning,
          AppColors.warning,
          'Need attention',
        ),
        _buildSummaryCard(
          'Out of Stock',
          controller.formatNumber(controller.analytics.value.outOfStockItems),
          Icons.error,
          AppColors.error,
          'Urgent attention',
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              title,
              style: Get.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              value,
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              subtitle,
              style: Get.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryValueTrendCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inventory Value Trend',
                  style: Get.textTheme.titleLarge,
                ),
                DropdownButton<String>(
                  value: controller.selectedPeriod.value,
                  items: ['7 Days', '30 Days', '90 Days']
                      .map((period) => DropdownMenuItem(
                            value: period,
                            child: Text(period),
                          ))
                      .toList(),
                  onChanged: controller.updatePeriod,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            controller.formatCurrencyCompact(value),
                            style: Get.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 5 != 0) return const Text('');
                          final date = controller
                              .analytics.value.valueTrend[value.toInt()].date;
                          return Text(
                            controller.formatDateShort(date),
                            style: Get.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.analytics.value.valueTrend
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.value,
                              ))
                          .toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) {
                        return Get.theme.colorScheme.surface;
                      },
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final date = controller
                              .analytics.value.valueTrend[spot.x.toInt()].date;
                          return LineTooltipItem(
                            '${controller.formatDateShort(date)}\n${controller.formatCurrency(spot.y)}',
                            Get.textTheme.bodySmall!,
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDistributionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Distribution',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.padding),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: controller.analytics.value.categoryDistribution
                      .map((category) => PieChartSectionData(
                            value: category.percentage.toDouble(),
                            color: category.color,
                            title: '${category.percentage.toStringAsFixed(0)}%',
                            radius: 100,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                      .toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.padding),
            ...controller.analytics.value.categoryDistribution.map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingSmall),
                    Expanded(
                      child: Text(
                        category.category,
                        style: Get.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      '${controller.formatNumber(category.count)} items',
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockItemsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Low Stock Items',
                  style: Get.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/low-stock'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            ...controller.analytics.value.lowStockItems.map(
              (item) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.stock <= 0
                        ? AppColors.error.withOpacity(0.2)
                        : AppColors.warning.withOpacity(0.2),
                    child: Icon(
                      item.stock <= 0 ? Icons.error : Icons.warning,
                      color:
                          item.stock <= 0 ? AppColors.error : AppColors.warning,
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    '${item.stock} of ${item.minimumStock} units remaining',
                  ),
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/reorder/${item.id}'),
                    child: const Text('Reorder'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringItemsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expiring Items',
                  style: Get.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/expiring-items'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: AppSizes.padding,
                columns: const [
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Batch')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Expiry Date')),
                  DataColumn(label: Text('Days Left')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: controller.analytics.value.expiringItems
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text(item.name)),
                          DataCell(Text(item.batchNumber)),
                          DataCell(Text(controller.formatNumber(item.stock))),
                          DataCell(
                              Text(controller.formatDate(item.expiryDate))),
                          DataCell(
                            Text(
                              '${item.daysUntilExpiry} days',
                              style: TextStyle(
                                color: item.daysUntilExpiry <= 30
                                    ? AppColors.error
                                    : item.daysUntilExpiry <= 90
                                        ? AppColors.warning
                                        : null,
                              ),
                            ),
                          ),
                          DataCell(
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed('/manage-expiry/${item.id}'),
                              child: const Text('Manage'),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
