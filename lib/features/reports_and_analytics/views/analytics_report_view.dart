import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/analytics_report_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../models/inventory_report_model.dart';

class AnalyticsReportView extends GetView<AnalyticsReportController> {
  const AnalyticsReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics & Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Sales'),
              Tab(text: 'Inventory'),
              Tab(text: 'Customers'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => _showExportDialog(context),
              tooltip: 'Export Report',
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterDialog(context),
              tooltip: 'Filter',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.refreshData,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _buildOverviewTab(),
                    _buildSalesTab(),
                    _buildInventoryTab(),
                    _buildCustomersTab(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeHeader(),
          const SizedBox(height: 16),
          _buildSummaryCards(),
          const SizedBox(height: 24),
          _buildRevenueChart(),
          const SizedBox(height: 24),
          _buildTopProducts(),
        ],
      ),
    );
  }

  Widget _buildDateRangeHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 8),
            Obx(() => Text(
                  '${controller.formatDate(controller.startDate.value)} - ${controller.formatDate(controller.endDate.value)}',
                  style: Get.textTheme.titleMedium,
                )),
            const Spacer(),
            TextButton(
              onPressed: () => _selectDateRange(Get.context!),
              child: const Text('Change Date Range'),
            ),
          ],
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
          controller.formatCurrency(controller.totalRevenue.value),
          Icons.attach_money,
          AppColors.success,
          controller.revenueGrowth.value >= 0
              ? '+${controller.formatPercentage(controller.revenueGrowth.value)}'
              : controller.formatPercentage(controller.revenueGrowth.value),
        ),
        _buildSummaryCard(
          'Total Orders',
          controller.formatNumber(controller.totalOrders.value),
          Icons.shopping_cart,
          AppColors.primary,
          '${controller.formatNumber(controller.averageOrderValue.value)} avg',
        ),
        _buildSummaryCard(
          'Active Products',
          controller.formatNumber(controller.totalProducts.value),
          Icons.inventory_2,
          AppColors.info,
          '${controller.formatNumber(controller.lowStockItems.value)} low stock',
        ),
        _buildSummaryCard(
          'Total Customers',
          controller.formatNumber(controller.totalCustomers.value),
          Icons.people,
          AppColors.warning,
          '+${controller.formatNumber(controller.newCustomers.value)} new',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Get.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Get.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(controller.revenueChartData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                DropdownButton<String>(
                  value: controller.topProductsMetric.value,
                  items: const [
                    DropdownMenuItem(
                      value: 'revenue',
                      child: Text('By Revenue'),
                    ),
                    DropdownMenuItem(
                      value: 'quantity',
                      child: Text('By Quantity'),
                    ),
                  ],
                  onChanged: controller.updateTopProductsMetric,
                ),
              ],
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Category')),
                DataColumn(
                  label: Text('Revenue'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Quantity'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Growth'),
                  numeric: true,
                ),
              ],
              rows: controller.topProducts.map((product) {
                return DataRow(
                  cells: [
                    DataCell(Text(product.name)),
                    DataCell(Text(product.category)),
                    DataCell(Text(controller.formatCurrency(product.revenue))),
                    DataCell(Text(controller.formatNumber(product.quantity))),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.growth >= 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: product.growth >= 0
                                ? AppColors.success
                                : AppColors.error,
                            size: 16,
                          ),
                          Text(controller.formatPercentage(product.growth)),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSalesMetrics(),
          const SizedBox(height: 24),
          _buildSalesByHourChart(),
          const SizedBox(height: 24),
          _buildSalesByCategory(),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInventoryMetrics(),
          const SizedBox(height: 24),
          _buildInventoryValueChart(),
          const SizedBox(height: 24),
          _buildLowStockItems(),
          const SizedBox(height: 24),
          _buildExpiringItems(),
        ],
      ),
    );
  }

  Widget _buildCustomersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomerMetrics(),
          const SizedBox(height: 24),
          _buildCustomerSegments(),
          const SizedBox(height: 24),
          _buildCustomerActivity(),
        ],
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDateRange: DateTimeRange(
        start: controller.startDate.value,
        end: controller.endDate.value,
      ),
    );
    if (picked != null) {
      controller.updateDateRange(picked.start, picked.end);
    }
  }

  void _showExportDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Export Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              onTap: () {
                Get.back();
                controller.exportReport(ReportFormat.pdf);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as Excel'),
              onTap: () {
                Get.back();
                controller.exportReport(ReportFormat.excel);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Export as CSV'),
              onTap: () {
                Get.back();
                controller.exportReport(ReportFormat.csv);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Filter Options'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateRangePicker(),
              const SizedBox(height: 16),
              _buildCategoryFilter(),
              const SizedBox(height: 16),
              _buildMetricsSelector(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date Range'),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => _selectDate(true),
                icon: const Icon(Icons.calendar_today),
                label: Obx(() => Text(
                      controller.formatDateShort(controller.startDate.value),
                    )),
              ),
            ),
            const Text(' - '),
            Expanded(
              child: TextButton.icon(
                onPressed: () => _selectDate(false),
                icon: const Icon(Icons.calendar_today),
                label: Obx(() => Text(
                      controller.formatDateShort(controller.endDate.value),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: isStartDate ? controller.startDate.value : controller.endDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      if (isStartDate) {
        controller.startDate.value = picked;
      } else {
        controller.endDate.value = picked;
      }
    }
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category'),
        DropdownButton<String>(
          value: controller.selectedCategory.value,
          isExpanded: true,
          items: controller.categories
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedCategory.value = value;
            }
          },
        ),
      ],
    );
  }

  Widget _buildMetricsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Metrics to Display'),
        Wrap(
          spacing: 8,
          children: controller.availableMetrics.map((metric) {
            return FilterChip(
              label: Text(metric),
              selected: controller.selectedMetrics.contains(metric),
              onSelected: (selected) {
                if (selected) {
                  controller.selectedMetrics.add(metric);
                } else {
                  controller.selectedMetrics.remove(metric);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Additional tab content widgets would be implemented here
  Widget _buildSalesMetrics() {
    // Implementation for sales metrics
    return const Placeholder(fallbackHeight: 200);
  }

  Widget _buildSalesByHourChart() {
    // Implementation for sales by hour chart
    return const Placeholder(fallbackHeight: 300);
  }

  Widget _buildSalesByCategory() {
    // Implementation for sales by category
    return const Placeholder(fallbackHeight: 300);
  }

  Widget _buildInventoryMetrics() {
    // Implementation for inventory metrics
    return const Placeholder(fallbackHeight: 200);
  }

  Widget _buildInventoryValueChart() {
    // Implementation for inventory value chart
    return const Placeholder(fallbackHeight: 300);
  }

  Widget _buildLowStockItems() {
    // Implementation for low stock items
    return const Placeholder(fallbackHeight: 200);
  }

  Widget _buildExpiringItems() {
    // Implementation for expiring items
    return const Placeholder(fallbackHeight: 200);
  }

  Widget _buildCustomerMetrics() {
    // Implementation for customer metrics
    return const Placeholder(fallbackHeight: 200);
  }

  Widget _buildCustomerSegments() {
    // Implementation for customer segments
    return const Placeholder(fallbackHeight: 300);
  }

  Widget _buildCustomerActivity() {
    // Implementation for customer activity
    return const Placeholder(fallbackHeight: 300);
  }
}
