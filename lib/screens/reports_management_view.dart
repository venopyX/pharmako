import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/reports_management_controller.dart';
import '../widgets/custom_card.dart';
import 'package:intl/intl.dart';

/// A comprehensive view for managing and viewing all reports
class ReportsManagementView extends GetView<ReportsManagementController> {
  const ReportsManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildSalesTab(),
            _buildInventoryTab(),
            _buildCustomerTab(),
            _buildOperationalTab(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Reports & Analytics'),
      actions: [
        IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: () => _showDateRangeDialog(),
        ),
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: controller.exportReport,
        ),
      ],
      bottom: const TabBar(
        isScrollable: true,
        tabs: [
          Tab(text: 'Overview'),
          Tab(text: 'Sales'),
          Tab(text: 'Inventory'),
          Tab(text: 'Customers'),
          Tab(text: 'Operations'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewMetrics(),
          const SizedBox(height: 24),
          _buildRevenueChart(),
          const SizedBox(height: 24),
          _buildCategoryPerformance(),
        ],
      ),
    );
  }

  Widget _buildOverviewMetrics() {
    return Obx(() {
      final overview = controller.reportData['overview'];
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildMetricCard(
            'Total Revenue',
            '\$${NumberFormat('#,##0.00').format(overview['totalRevenue'])}',
            Icons.attach_money,
            Colors.green,
          ),
          _buildMetricCard(
            'Total Orders',
            NumberFormat('#,##0').format(overview['totalOrders']),
            Icons.shopping_cart,
            Colors.blue,
          ),
          _buildMetricCard(
            'Average Order Value',
            '\$${NumberFormat('#,##0.00').format(overview['averageOrderValue'])}',
            Icons.trending_up,
            Colors.orange,
          ),
          _buildMetricCard(
            'Total Customers',
            NumberFormat('#,##0').format(overview['totalCustomers']),
            Icons.people,
            Colors.purple,
          ),
        ],
      );
    });
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Obx(() {
      final salesTrends = controller.reportData['salesTrends'];
      final dailyData = salesTrends['daily'] as List;
      
      return CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Revenue Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  // TODO: Implement chart data
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryPerformance() {
    return Obx(() {
      final categories = controller.reportData['categoryPerformance'] as List;
      return CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Category Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category['category']),
                  subtitle: Text(
                    'Quantity: ${NumberFormat('#,##0').format(category['quantity'])}',
                  ),
                  trailing: Text(
                    '\$${NumberFormat('#,##0.00').format(category['sales'])}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSalesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSalesMetrics(),
          const SizedBox(height: 24),
          _buildProfitMargins(),
          const SizedBox(height: 24),
          _buildPrescriptionStats(),
        ],
      ),
    );
  }

  Widget _buildSalesMetrics() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales Overview', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMetricCard(
                'Total Sales',
                controller.totalSales.value.toStringAsFixed(2),
                Icons.attach_money,
                Colors.green,
              ),
              _buildMetricCard(
                'Orders',
                controller.totalOrders.toString(),
                Icons.shopping_cart,
                Colors.blue,
              ),
              _buildMetricCard(
                'Average Order',
                controller.averageOrderValue.value.toStringAsFixed(2),
                Icons.analytics,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfitMargins() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profit Analysis', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              controller.getProfitMarginChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionStats() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prescription Statistics', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMetricCard(
                'Total Prescriptions',
                controller.totalPrescriptions.toString(),
                Icons.medical_services,
                Colors.purple,
              ),
              _buildMetricCard(
                'Average Items',
                controller.averagePrescriptionItems.toStringAsFixed(1),
                Icons.list_alt,
                Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInventoryMetrics(),
          const SizedBox(height: 24),
          _buildLowStockItems(),
          const SizedBox(height: 24),
          _buildExpiringItems(),
        ],
      ),
    );
  }

  Widget _buildInventoryMetrics() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inventory Overview', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMetricCard(
                'Total Items',
                controller.totalInventoryItems.toString(),
                Icons.inventory_2,
                Colors.blue,
              ),
              _buildMetricCard(
                'Stock Value',
                controller.totalStockValue.value.toStringAsFixed(2),
                Icons.account_balance_wallet,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockItems() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Low Stock Items', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.lowStockItems.length,
            itemBuilder: (context, index) {
              final item = controller.lowStockItems[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('Current Stock: ${item.quantity}'),
                trailing: Text('Min: ${item.minQuantity}'),
                leading: const Icon(Icons.warning, color: Colors.orange),
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildExpiringItems() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Expiring Items', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.expiringItems.length,
            itemBuilder: (context, index) {
              final item = controller.expiringItems[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('Expires: ${item.expiryDate}'),
                leading: const Icon(Icons.event, color: Colors.red),
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildCustomerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCustomerMetrics(),
          const SizedBox(height: 24),
          _buildTopCustomers(),
          const SizedBox(height: 24),
          _buildCustomerTrends(),
        ],
      ),
    );
  }

  Widget _buildCustomerMetrics() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Overview', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMetricCard(
                'Total Customers',
                controller.totalCustomers.toString(),
                Icons.people,
                Colors.blue,
              ),
              _buildMetricCard(
                'Active Customers',
                controller.activeCustomers.toString(),
                Icons.person,
                Colors.green,
              ),
              _buildMetricCard(
                'Customer Growth',
                '${controller.customerGrowth.toStringAsFixed(1)}%',
                Icons.trending_up,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopCustomers() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Customers', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.topCustomers.length,
            itemBuilder: (context, index) {
              final customer = controller.topCustomers[index];
              return ListTile(
                title: Text(customer.name),
                subtitle: Text('Total Purchases: ${customer.totalPurchases}'),
                trailing: Text('\$${customer.totalSpent.toStringAsFixed(2)}'),
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildCustomerTrends() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Trends', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              controller.getCustomerTrendsChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildOperationalMetrics(),
          const SizedBox(height: 24),
          _buildPeakHours(),
          const SizedBox(height: 24),
          _buildEfficiencyMetrics(),
        ],
      ),
    );
  }

  Widget _buildOperationalMetrics() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Operational Overview', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMetricCard(
                'Order Processing',
                '${controller.averageProcessingTime.toStringAsFixed(1)} min',
                Icons.timer,
                Colors.blue,
              ),
              _buildMetricCard(
                'Staff Efficiency',
                '${controller.staffEfficiency.toStringAsFixed(1)}%',
                Icons.person_outline,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeakHours() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Peak Hours Analysis', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              controller.getPeakHoursChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyMetrics() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Efficiency Metrics', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMetricCard(
                'Order Accuracy',
                '${controller.orderAccuracy.toStringAsFixed(1)}%',
                Icons.check_circle_outline,
                Colors.green,
              ),
              _buildMetricCard(
                'Return Rate',
                '${controller.returnRate.toStringAsFixed(1)}%',
                Icons.replay,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDateRangeDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Date Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Today'),
              onTap: () {
                controller.setDateRange('today');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('This Week'),
              onTap: () {
                controller.setDateRange('week');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('This Month'),
              onTap: () {
                controller.setDateRange('month');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Custom Range'),
              onTap: () async {
                Get.back();
                final picked = await showDateRangePicker(
                  context: Get.context!,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.setCustomDateRange(picked.start, picked.end);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
