import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_analytics_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class DashboardAnalyticsView extends GetView<DashboardAnalyticsController> {
  const DashboardAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Analytics'),
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
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetricsGrid(),
                    const SizedBox(height: AppSizes.padding),
                    _buildSalesTrendCard(),
                    const SizedBox(height: AppSizes.padding),
                    _buildInventoryOverviewCard(),
                    const SizedBox(height: AppSizes.padding),
                    _buildCustomerSegmentsCard(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: AppSizes.padding,
      crossAxisSpacing: AppSizes.padding,
      children: [
        _buildMetricCard(
          'Total Revenue',
          controller.formatCurrency(controller.analytics.value!.sales.totalRevenue),
          Icons.attach_money,
          AppColors.success,
          '${controller.analytics.value!.sales.growthRate.toStringAsFixed(1)}% growth',
          () => Get.toNamed('/sales-analytics'),
        ),
        _buildMetricCard(
          'Total Products',
          controller.formatNumber(controller.analytics.value!.inventory.totalProducts),
          Icons.inventory_2,
          AppColors.info,
          '${controller.analytics.value!.inventory.lowStockItems} low stock',
          () => Get.toNamed('/inventory-analytics'),
        ),
        _buildMetricCard(
          'Total Customers',
          controller.formatNumber(controller.analytics.value!.customers.totalCustomers),
          Icons.people,
          AppColors.warning,
          '${controller.analytics.value!.customers.customerGrowthRate.toStringAsFixed(1)}% growth',
          () => Get.toNamed('/customer-analytics'),
        ),
        _buildMetricCard(
          'Average Order',
          controller.formatCurrency(controller.analytics.value!.sales.averageOrderValue),
          Icons.shopping_cart,
          AppColors.primary,
          '${controller.analytics.value!.sales.totalSales} orders',
          () => Get.toNamed('/order-analytics'),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radius),
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
                DropdownButton<String>(
                  value: controller.selectedTrendPeriod.value,
                  items: ['7 Days', '30 Days', '90 Days']
                      .map((period) => DropdownMenuItem(
                            value: period,
                            child: Text(period),
                          ))
                      .toList(),
                  onChanged: (value) => controller.updateTrendPeriod(value ?? '7 Days'),
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
                          final date = controller.analytics.value!.sales.salesTrend[value.toInt()].date;
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
                      spots: controller.analytics.value!.sales.salesTrend
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
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final date = controller.analytics.value!.sales.salesTrend[spot.x.toInt()].date;
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

  Widget _buildInventoryOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Overview',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.padding),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: controller
                            .analytics.value!.inventory.categoryDistribution
                            .map((category) => PieChartSectionData(
                                  value: category.percentage.toDouble(),
                                  color: category.color,
                                  title:
                                      '${category.percentage.toStringAsFixed(0)}%',
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
                ),
                const SizedBox(width: AppSizes.padding),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller
                        .analytics.value!.inventory.categoryDistribution
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSizes.paddingSmall),
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
                                  controller.formatNumber(category.count),
                                  style: Get.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
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
            ...controller.analytics.value!.customers.segments.map(
              (segment) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          segment.name,
                          style: Get.textTheme.titleSmall,
                        ),
                        Text(
                          '${segment.percentage}%',
                          style: Get.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingSmall),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusLarge),
                      child: LinearProgressIndicator(
                        value: segment.percentage / 100,
                        backgroundColor: segment.color.withOpacity(0.2),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(segment.color),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.formatNumber(segment.count)} customers',
                          style: Get.textTheme.bodySmall,
                        ),
                        Text(
                          'Value: ${controller.formatCurrency(segment.totalValue)}',
                          style: Get.textTheme.bodySmall,
                        ),
                      ],
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
}
