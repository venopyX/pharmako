import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/sales_analytics_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class SalesAnalyticsView extends GetView<SalesAnalyticsController> {
  const SalesAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Analytics'),
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
                    _buildSalesTrendCard(),
                    const SizedBox(height: AppSizes.padding),
                    _buildTopSellingProductsCard(),
                    const SizedBox(height: AppSizes.padding),
                    _buildSalesByHourCard(),
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
          'Total Revenue',
          controller.formatCurrency(controller.analytics.value.totalRevenue),
          Icons.attach_money,
          AppColors.success,
          '${(controller.analytics.value.growthRate.toDouble()).toStringAsFixed(1)}% vs last period',
        ),
        _buildSummaryCard(
          'Total Sales',
          controller
              .formatNumber(controller.analytics.value.totalSales.toDouble()),
          Icons.shopping_cart,
          AppColors.info,
          '${(controller.analytics.value.salesGrowthRate.toDouble()).toStringAsFixed(1)}% vs last period',
        ),
        _buildSummaryCard(
          'Average Order',
          controller
              .formatCurrency(controller.analytics.value.averageOrderValue),
          Icons.trending_up,
          AppColors.warning,
          '${(controller.analytics.value.orderValueGrowthRate.toDouble()).toStringAsFixed(1)}% vs last period',
        ),
        _buildSummaryCard(
          'Conversion Rate',
          '${(controller.analytics.value.conversionRate.toDouble()).toStringAsFixed(1)}%',
          Icons.people,
          AppColors.primary,
          '${(controller.analytics.value.conversionRateGrowthRate.toDouble()).toStringAsFixed(1)}% vs last period',
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

  Widget _buildSalesTrendCard() {
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
                  'Sales Trend',
                  style: Get.textTheme.titleLarge,
                ),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: controller.selectedMetric.value,
                      items: ['Revenue', 'Orders', 'Average Order']
                          .map((metric) => DropdownMenuItem(
                                value: metric,
                                child: Text(metric),
                              ))
                          .toList(),
                      onChanged: controller.updateMetric,
                    ),
                    const SizedBox(width: AppSizes.padding),
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
                            controller.formatMetricValue(value),
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
                              .analytics.value.salesTrend[value.toInt()].date;
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
                      spots: controller.getChartData(),
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
                              .analytics.value.salesTrend[spot.x.toInt()].date;
                          return LineTooltipItem(
                            '${controller.formatDateShort(date)}\n${controller.formatMetricValue(spot.y)}',
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

  Widget _buildTopSellingProductsCard() {
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
                  'Top Selling Products',
                  style: Get.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/product-analytics'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            DataTable(
              columnSpacing: AppSizes.padding,
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Category')),
                DataColumn(
                  label: Text('Units Sold'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Revenue'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Growth'),
                  numeric: true,
                ),
              ],
              rows: controller.analytics.value.topProducts
                  .map(
                    (product) => DataRow(
                      cells: [
                        DataCell(Text(product.name)),
                        DataCell(Text(product.category)),
                        DataCell(Text(controller
                            .formatNumber(product.unitsSold.toDouble()))),
                        DataCell(
                            Text(controller.formatCurrency(product.revenue))),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                product.growthRate >= 0
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 16,
                                color: product.growthRate >= 0
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                              Text(
                                '${(product.growthRate.toDouble()).abs().toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: product.growthRate >= 0
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesByHourCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales by Hour',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.padding),
            SizedBox(
              height: 200,
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
                            '${value.toInt()}:00',
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
                  barGroups: controller.analytics.value.salesByHour
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
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
}
