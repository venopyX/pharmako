import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/custom_card.dart';
import '../widgets/stat_card.dart';

/// A view for displaying the pharmacy dashboard
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: controller.showDatePicker,
          ),
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
        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateRangeHeader(),
                const SizedBox(height: 16),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildSummaryCards(context),
                const SizedBox(height: 24),
                _buildCharts(),
                const SizedBox(height: 24),
                _buildTopProducts(),
                const SizedBox(height: 24),
                _buildRecentAlerts(),
                const SizedBox(height: 24),
                _buildUpcomingExpiries(),
              ],
            ),
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

  Widget _buildDateRangeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Text(
          controller.dateRangeText.value,
          style: Get.textTheme.titleLarge,
        )),
        DropdownButton<String>(
          value: controller.selectedRange.value,
          items: [
            'Today',
            'Yesterday',
            'Last 7 Days',
            'Last 30 Days',
            'This Month',
            'Last Month',
            'Custom Range',
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: controller.updateDateRange,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionButton(
          'New Sale',
          Icons.point_of_sale,
          () => Get.toNamed('/sale'),
          Colors.blue,
        ),
        _buildActionButton(
          'Add Stock',
          Icons.add_shopping_cart,
          () => Get.toNamed('/add-stock'),
          Colors.green,
        ),
        _buildActionButton(
          'View Reports',
          Icons.bar_chart,
          () => Get.toNamed('/reports'),
          Colors.purple,
        ),
        _buildActionButton(
          'Check Expiry',
          Icons.timer,
          () => Get.toNamed('/expiry'),
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
          childAspectRatio: constraints.maxWidth < 600 ? 1.3 : 1.5,
          padding: EdgeInsets.zero,
          children: [
            StatCard(
              title: 'Total Sales',
              value: '\$${controller.summary.value.totalSales.toStringAsFixed(2)}',
              icon: Icons.attach_money,
              color: Colors.green,
              trend: controller.salesTrend.value,
              onTap: () => Get.toNamed('/sales'),
            ),
            StatCard(
              title: 'Total Products',
              value: controller.summary.value.totalProducts.toString(),
              icon: Icons.inventory,
              color: Colors.blue,
              trend: 0,
              onTap: () => Get.toNamed('/inventory'),
            ),
            StatCard(
              title: 'Low Stock',
              value: controller.summary.value.lowStockItems.toString(),
              icon: Icons.warning,
              color: Colors.orange,
              trend: controller.lowStockTrend.value,
              onTap: () => Get.toNamed('/low-stock'),
            ),
            StatCard(
              title: 'Expiring Soon',
              value: controller.summary.value.expiringItems.toString(),
              icon: Icons.timer,
              color: Colors.red,
              trend: controller.expiryTrend.value,
              onTap: () => Get.toNamed('/expiring'),
            ),
            StatCard(
              title: 'Orders',
              value: controller.summary.value.pendingOrders.toString(),
              icon: Icons.shopping_cart,
              color: Colors.purple,
              trend: controller.ordersTrend.value,
              onTap: () => Get.toNamed('/orders'),
            ),
            StatCard(
              title: 'Profit',
              value: '\$${controller.summary.value.profit.toStringAsFixed(2)}',
              icon: Icons.trending_up,
              color: Colors.teal,
              trend: controller.profitTrend.value,
              onTap: () => Get.toNamed('/reports'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCharts() {
    return Column(
      children: [
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sales Overview',
                    style: Get.textTheme.titleLarge,
                  ),
                  DropdownButton<String>(
                    value: controller.selectedChartType.value,
                    items: [
                      'Daily',
                      'Weekly',
                      'Monthly',
                      'Yearly',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: controller.updateChartType,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: Obx(() {
                  if (controller.selectedChartType.value == 'Daily') {
                    return _buildBarChart();
                  } else {
                    return _buildLineChart();
                  }
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category Distribution',
                      style: Get.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: controller.categoryData.map((item) {
                            return PieChartSectionData(
                              value: item.value,
                              title: '${item.label}\n${item.value.toStringAsFixed(1)}%',
                              color: item.color,
                              radius: 100,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Sources',
                      style: Get.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: controller.revenueData.map((item) {
                            return PieChartSectionData(
                              value: item.value,
                              title: '${item.label}\n${item.value.toStringAsFixed(1)}%',
                              color: item.color,
                              radius: 100,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return BarChart(
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
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
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
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: controller.salesData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.value);
            }).toList(),
            isCurved: true,
            color: Get.theme.primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Get.theme.primaryColor.withAlpha(25),  // 0.1 opacity is approximately 25 in alpha (255 * 0.1)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Products',
                style: Get.textTheme.titleLarge,
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed('/reports'),
                icon: const Icon(Icons.analytics),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Sales')),
                DataColumn(label: Text('Revenue')),
                DataColumn(label: Text('Stock')),
              ],
              rows: controller.topProducts.map((product) {
                return DataRow(cells: [
                  DataCell(Text(product.name)),
                  DataCell(Text(product.category)),
                  DataCell(Text(product.sales.toString())),
                  DataCell(Text('\$${product.revenue.toStringAsFixed(2)}')),
                  DataCell(Text(product.stock.toString())),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAlerts() {
    return CustomCard(
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
    );
  }

  Widget _buildUpcomingExpiries() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Expiries',
                style: Get.textTheme.titleLarge,
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed('/expiry'),
                icon: const Icon(Icons.timer),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Batch')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Expiry Date')),
                DataColumn(label: Text('Days Left')),
              ],
              rows: controller.upcomingExpiries.map((expiry) {
                return DataRow(cells: [
                  DataCell(Text(expiry.productName)),
                  DataCell(Text(expiry.batchNumber)),
                  DataCell(Text(expiry.quantity.toString())),
                  DataCell(Text(expiry.expiryDate)),
                  DataCell(
                    Text(
                      expiry.daysLeft.toString(),
                      style: TextStyle(
                        color: expiry.daysLeft < 30 ? Colors.red : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}