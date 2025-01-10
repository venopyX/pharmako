import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inventory_report_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../models/inventory_report_model.dart';

class InventoryReportView extends GetView<InventoryReportController> {
  const InventoryReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Report',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => controller.exportReport(ReportFormat.pdf),
            tooltip: 'Export as PDF',
          ),
          PopupMenuButton<ReportFormat>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More Options',
            onSelected: controller.exportReport,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ReportFormat.excel,
                child: Text('Export as Excel'),
              ),
              const PopupMenuItem(
                value: ReportFormat.csv,
                child: Text('Export as CSV'),
              ),
            ],
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
                    _buildReportHeader(),
                    const SizedBox(height: AppSizes.padding),
                    _buildSummaryCards(),
                    const SizedBox(height: AppSizes.padding),
                    _buildInventoryTable(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildReportHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.report.value?.title ?? '',
                      style: Get.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Generated on ${controller.formatDate(controller.report.value?.generatedAt ?? DateTime.now())}',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    controller.report.value?.type.toString().split('.').last.toUpperCase() ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.padding),
            Row(
              children: [
                _buildDateRangeChip(
                  'From',
                  controller.report.value?.startDate ?? DateTime.now(),
                ),
                const SizedBox(width: 8),
                _buildDateRangeChip(
                  'To',
                  controller.report.value?.endDate ?? DateTime.now(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeChip(String label, DateTime date) {
    return Chip(
      label: Text(
        '$label: ${controller.formatDateShort(date)}',
        style: const TextStyle(color: Colors.white70),
      ),
      backgroundColor: AppColors.primary.withOpacity(0.8),
    );
  }

  Widget _buildSummaryCards() {
    final summary = controller.report.value?.summary;
    if (summary == null) return const SizedBox();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: AppSizes.padding,
      crossAxisSpacing: AppSizes.padding,
      children: [
        _buildSummaryCard(
          'Total Products',
          controller.formatNumber(summary.totalProducts),
          Icons.inventory_2,
          AppColors.primary,
        ),
        _buildSummaryCard(
          'Total Value',
          controller.formatCurrency(summary.totalValue),
          Icons.attach_money,
          AppColors.success,
        ),
        _buildSummaryCard(
          'Stock Movement',
          '${controller.formatNumber(summary.totalStockMovement)} units',
          Icons.swap_horiz,
          AppColors.info,
        ),
        _buildSummaryCard(
          'Categories',
          controller.formatNumber(summary.categories.length),
          Icons.category,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Get.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTable() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            if (controller.selectedColumns.contains('productName'))
              const DataColumn(label: Text('Product Name')),
            if (controller.selectedColumns.contains('category'))
              const DataColumn(label: Text('Category')),
            if (controller.selectedColumns.contains('openingStock'))
              const DataColumn(label: Text('Opening Stock')),
            if (controller.selectedColumns.contains('closingStock'))
              const DataColumn(label: Text('Closing Stock')),
            if (controller.selectedColumns.contains('stockReceived'))
              const DataColumn(label: Text('Stock Received')),
            if (controller.selectedColumns.contains('stockSold'))
              const DataColumn(label: Text('Stock Sold')),
            if (controller.selectedColumns.contains('averagePrice'))
              const DataColumn(label: Text('Average Price')),
            if (controller.selectedColumns.contains('totalValue'))
              const DataColumn(label: Text('Total Value')),
            if (controller.selectedColumns.contains('expiryDate'))
              const DataColumn(label: Text('Expiry Date')),
          ],
          rows: controller.report.value?.items.map((item) {
                return DataRow(
                  cells: [
                    if (controller.selectedColumns.contains('productName'))
                      DataCell(Text(item.productName)),
                    if (controller.selectedColumns.contains('category'))
                      DataCell(Text(item.category)),
                    if (controller.selectedColumns.contains('openingStock'))
                      DataCell(Text(controller.formatNumber(item.openingStock))),
                    if (controller.selectedColumns.contains('closingStock'))
                      DataCell(Text(controller.formatNumber(item.closingStock))),
                    if (controller.selectedColumns.contains('stockReceived'))
                      DataCell(Text(controller.formatNumber(item.stockReceived))),
                    if (controller.selectedColumns.contains('stockSold'))
                      DataCell(Text(controller.formatNumber(item.stockSold))),
                    if (controller.selectedColumns.contains('averagePrice'))
                      DataCell(Text(controller.formatCurrency(item.averagePrice))),
                    if (controller.selectedColumns.contains('totalValue'))
                      DataCell(Text(controller.formatCurrency(item.totalValue))),
                    if (controller.selectedColumns.contains('expiryDate'))
                      DataCell(Text(item.expiryDate != null
                          ? controller.formatDateShort(item.expiryDate!)
                          : '-')),
                  ],
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Filter Report'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateRangePicker(),
              const SizedBox(height: 16),
              _buildReportTypeDropdown(),
              const SizedBox(height: 16),
              _buildColumnSelector(),
              const SizedBox(height: 16),
              _buildCategoryFilter(),
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
              controller.generateReport();
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isStartDate) {
        controller.startDate.value = picked;
      } else {
        controller.endDate.value = picked;
      }
    }
  }

  Widget _buildReportTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Report Type'),
        DropdownButton<String>(
          value: controller.selectedReportType.value,
          isExpanded: true,
          items: ReportType.values
              .map((type) => DropdownMenuItem(
                    value: type.toString(),
                    child: Text(type.toString().split('.').last.toUpperCase()),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedReportType.value = value;
            }
          },
        ),
      ],
    );
  }

  Widget _buildColumnSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Columns to Display'),
        Wrap(
          spacing: 8,
          children: [
            _buildColumnCheckbox('Product Name', 'productName'),
            _buildColumnCheckbox('Category', 'category'),
            _buildColumnCheckbox('Opening Stock', 'openingStock'),
            _buildColumnCheckbox('Closing Stock', 'closingStock'),
            _buildColumnCheckbox('Stock Received', 'stockReceived'),
            _buildColumnCheckbox('Stock Sold', 'stockSold'),
            _buildColumnCheckbox('Average Price', 'averagePrice'),
            _buildColumnCheckbox('Total Value', 'totalValue'),
            _buildColumnCheckbox('Expiry Date', 'expiryDate'),
          ],
        ),
      ],
    );
  }

  Widget _buildColumnCheckbox(String label, String value) {
    return Obx(
      () => CheckboxListTile(
        title: Text(label),
        value: controller.selectedColumns.contains(value),
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? checked) {
          if (checked == true) {
            controller.selectedColumns.add(value);
          } else {
            controller.selectedColumns.remove(value);
          }
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category'),
        DropdownButton<String>(
          value: controller.selectedCategory.value,
          isExpanded: true,
          items: ['All', 'Antibiotics', 'Pain Relief', 'Vitamins', 'First Aid']
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
}
