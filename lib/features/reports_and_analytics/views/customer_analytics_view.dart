import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/customer_analytics_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class CustomerAnalyticsView extends GetView<CustomerAnalyticsController> {
  const CustomerAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Analytics'),
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
                    _buildCustomerTrendCard(),
                    const SizedBox(height: AppSizes.padding),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildCustomerSegmentsCard()),
                        const SizedBox(width: AppSizes.padding),
                        Expanded(child: _buildCustomerLifetimeValueCard()),
                      ],
                    ),
                    const SizedBox(height: AppSizes.padding),
                    _buildTopCustomersCard(),
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
          'Total Customers',
          controller.formatNumber(controller.analytics.value.totalCustomers),
          Icons.people,
          AppColors.primary,
          '${controller.analytics.value.customerGrowthRate}% growth',
        ),
        _buildSummaryCard(
          'Active Customers',
          controller.formatNumber(controller.analytics.value.activeCustomers),
          Icons.person,
          AppColors.success,
          '${controller.analytics.value.activeCustomerRate}% active',
        ),
        _buildSummaryCard(
          'Average Value',
          controller
              .formatCurrency(controller.analytics.value.averageCustomerValue),
          Icons.attach_money,
          AppColors.warning,
          'Per customer',
        ),
        _buildSummaryCard(
          'Retention Rate',
          '${controller.analytics.value.retentionRate}%',
          Icons.repeat,
          AppColors.info,
          'Last 30 days',
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

  Widget _buildCustomerTrendCard() {
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
                  'Customer Growth',
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
                          final date = controller.analytics.value
                              .customerTrend[value.toInt()].date;
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
                      spots: controller.analytics.value.customerTrend
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
                          final date = controller.analytics.value
                              .customerTrend[spot.x.toInt()].date;
                          return LineTooltipItem(
                            '${controller.formatDateShort(date)}\n${controller.formatNumber(spot.y)} customers',
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

  Widget _buildCustomerSegmentsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Segments',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.padding),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: controller.analytics.value.segments
                      .map((segment) => PieChartSectionData(
                            value: segment.percentage.toDouble(),
                            color: segment.color,
                            title: '${segment.percentage.toStringAsFixed(0)}%',
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
            ...controller.analytics.value.segments.map(
              (segment) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: segment.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingSmall),
                    Expanded(
                      child: Text(
                        segment.name,
                        style: Get.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      '${controller.formatNumber(segment.count)} customers',
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

  Widget _buildCustomerLifetimeValueCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Lifetime Value',
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
                          return Text(
                            controller
                                .analytics.value.segments[value.toInt()].name,
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
                  barGroups: controller.analytics.value.segments
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.averageValue,
                              color: entry.value.color,
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

  Widget _buildTopCustomersCard() {
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
                  'Top Customers',
                  style: Get.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/customer-list'),
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
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Segment')),
                  DataColumn(
                    label: Text('Total Orders'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Total Value'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Last Order'),
                  ),
                  DataColumn(
                    label: Text('Actions'),
                  ),
                ],
                rows: controller.analytics.value.topCustomers
                    .map(
                      (customer) => DataRow(
                        cells: [
                          DataCell(Text(customer.name)),
                          DataCell(Text(customer.segment)),
                          DataCell(Text(
                              controller.formatNumber(customer.totalOrders))),
                          DataCell(Text(
                              controller.formatCurrency(customer.totalValue))),
                          DataCell(
                              Text(controller.formatDate(customer.lastOrder))),
                          DataCell(
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed('/customer/${customer.id}'),
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
