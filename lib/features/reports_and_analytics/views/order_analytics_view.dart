import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/order_analytics_controller.dart';

class OrderAnalyticsView extends GetView<OrderAnalyticsController> {
  const OrderAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Analytics'),
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
                    _buildOrderTrendCard(),
                    const SizedBox(height: AppSizes.padding),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildOrderValueDistributionCard()),
                        const SizedBox(width: AppSizes.padding),
                        Expanded(child: _buildOrderStatusDistributionCard()),
                      ],
                    ),
                    const SizedBox(height: AppSizes.padding),
                    _buildRecentOrdersCard(),
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
          'Total Orders',
          controller.formatNumber(controller.analytics.value.totalOrders),
          Icons.shopping_cart,
          AppColors.primary,
          '${controller.analytics.value.orderGrowthRate}% growth',
        ),
        _buildSummaryCard(
          'Average Order Value',
          controller
              .formatCurrency(controller.analytics.value.averageOrderValue),
          Icons.attach_money,
          AppColors.success,
          'Per order',
        ),
        _buildSummaryCard(
          'Order Frequency',
          '${controller.analytics.value.orderFrequency} per day',
          Icons.access_time,
          AppColors.warning,
          'Last 30 days',
        ),
        _buildSummaryCard(
          'Completion Rate',
          '${controller.analytics.value.completionRate}%',
          Icons.check_circle,
          AppColors.info,
          'Orders completed',
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

  Widget _buildOrderTrendCard() {
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
                  'Order Trend',
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
                            controller.formatNumber(value),
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
                              .analytics.value.orderTrend[value.toInt()].date;
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
                      spots: controller.analytics.value.orderTrend
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.count.toDouble(),
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
                              .analytics.value.orderTrend[spot.x.toInt()].date;
                          return LineTooltipItem(
                            '${controller.formatDateShort(date)}\n${controller.formatNumber(spot.y)} orders',
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

  Widget _buildOrderValueDistributionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Value Distribution',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.padding),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            controller.formatNumber(value),
                            style: Get.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            controller.analytics.value
                                .valueDistribution[value.toInt()].range,
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
                  barGroups: controller.analytics.value.valueDistribution
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.count.toDouble(),
                              color: AppColors.primary,
                              width: 16,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppSizes.radiusSmall),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusDistributionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status Distribution',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.padding),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: controller.analytics.value.statusDistribution
                      .map((status) => PieChartSectionData(
                            value: status.percentage.toDouble(),
                            color: status.color,
                            title: '${status.percentage.toStringAsFixed(0)}%',
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
            ...controller.analytics.value.statusDistribution.map(
              (status) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: status.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingSmall),
                    Expanded(
                      child: Text(
                        status.name,
                        style: Get.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      '${controller.formatNumber(status.count)} orders',
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

  Widget _buildRecentOrdersCard() {
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
                  'Recent Orders',
                  style: Get.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/orders'),
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
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(
                    label: Text('Items'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Total Value'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Status'),
                  ),
                  DataColumn(
                    label: Text('Date'),
                  ),
                  DataColumn(
                    label: Text('Actions'),
                  ),
                ],
                rows: controller.analytics.value.recentOrders
                    .map(
                      (order) => DataRow(
                        cells: [
                          DataCell(Text(order.id)),
                          DataCell(Text(order.customerName)),
                          DataCell(
                              Text(controller.formatNumber(order.itemCount))),
                          DataCell(Text(
                              controller.formatCurrency(order.totalValue))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.paddingSmall,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: order.statusColor.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusSmall),
                              ),
                              child: Text(
                                order.status,
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: order.statusColor,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(controller.formatDate(order.date))),
                          DataCell(
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed('/orders/${order.id}'),
                              child: const Text('View'),
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
