import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sales_management_controller.dart';
import '../models/sale_transaction.dart';
import '../widgets/custom_card.dart';
import '../widgets/animated_loading.dart';
import 'package:intl/intl.dart';

/// A comprehensive view for managing sales and viewing analytics
class SalesManagementView extends GetView<SalesManagementController> {
  const SalesManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            _buildPOSView(),
            _buildTransactionsView(),
            _buildAnalyticsView(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Sales Management'),
      bottom: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.point_of_sale), text: 'POS'),
          Tab(icon: Icon(Icons.receipt_long), text: 'Transactions'),
          Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () => Get.toNamed('/notifications'),
        ),
      ],
    );
  }

  Widget _buildPOSView() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildProductGrid(),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _buildCart(),
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: controller.onSearchChanged,
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const AnimatedLoading();
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = controller.filteredProducts[index];
                return CustomCard(
                  onTap: () => controller.addToCart(product),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medication,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCart() {
    return Column(
      children: [
        Expanded(
          child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.cartItems.length,
            itemBuilder: (context, index) {
              final item = controller.cartItems[index];
              return Card(
                child: ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('\$${item.total.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => controller.decreaseQuantity(index),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => controller.increaseQuantity(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => controller.removeFromCart(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        ),
        _buildCartSummary(),
      ],
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() => Text(
                '\$${controller.cartTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(Get.context!).primaryColor,
                ),
              )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  onPressed: controller.clearCart,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: const Text('Checkout'),
                  onPressed: () => _showCheckoutDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsView() {
    return Column(
      children: [
        _buildTransactionFilters(),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const AnimatedLoading();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.transactions.length,
              itemBuilder: (context, index) {
                final transaction = controller.transactions[index];
                return _buildTransactionCard(transaction);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTransactionFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: controller.onTransactionSearchChanged,
            ),
          ),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: controller.setTransactionFilter,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Transactions'),
              ),
              const PopupMenuItem(
                value: 'today',
                child: Text('Today'),
              ),
              const PopupMenuItem(
                value: 'week',
                child: Text('This Week'),
              ),
              const PopupMenuItem(
                value: 'month',
                child: Text('This Month'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(SaleTransaction transaction) {
    return CustomCard(
      child: ExpansionTile(
        title: Text(
          'Transaction #${transaction.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${transaction.customerName} - ${DateFormat('MMM dd, yyyy HH:mm').format(transaction.transactionDate)}',
        ),
        trailing: Text(
          '\$${transaction.total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          ...transaction.items.map((item) => ListTile(
            title: Text(item.product.name),
            subtitle: Text('${item.quantity} x \$${item.priceAtSale}'),
            trailing: Text('\$${item.total.toStringAsFixed(2)}'),
          )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Method: ${transaction.paymentMethod}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (transaction.prescriptionId != null)
                  Text(
                    'RX: ${transaction.prescriptionId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSalesOverview(),
          const SizedBox(height: 24),
          _buildSalesChart(),
          const SizedBox(height: 24),
          _buildPopularItems(),
          const SizedBox(height: 24),
          _buildPaymentMethodsChart(),
        ],
      ),
    );
  }

  Widget _buildSalesOverview() {
    return Obx(() {
      final stats = controller.salesStats;
      return Row(
        children: [
          _buildStatCard(
            'Today\'s Sales',
            '\$${stats['todaySales'].toStringAsFixed(2)}',
            Icons.today,
          ),
          _buildStatCard(
            'Weekly Sales',
            '\$${stats['weekSales'].toStringAsFixed(2)}',
            Icons.calendar_view_week,
          ),
          _buildStatCard(
            'Monthly Sales',
            '\$${stats['monthSales'].toStringAsFixed(2)}',
            Icons.calendar_month,
          ),
        ].map((widget) => Expanded(child: widget)).toList(),
      );
    });
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return const CustomCard(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Text('Sales Chart Placeholder'),
        ),
      ),
    );
  }

  Widget _buildPopularItems() {
    return Obx(() {
      final popularItems = controller.salesStats['popularItems'] as List;
      return CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Popular Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: popularItems.length,
              itemBuilder: (context, index) {
                final item = popularItems[index];
                return ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: Text(item['name']),
                  trailing: Text(
                    '${item['count']} sales',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPaymentMethodsChart() {
    return const CustomCard(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Text('Payment Methods Chart Placeholder'),
        ),
      ),
    );
  }

  void _showCheckoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: controller.setCustomerName,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                prefixIcon: Icon(Icons.payment),
              ),
              items: ['Cash', 'Credit Card', 'Insurance']
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: controller.setPaymentMethod,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.checkout();
              Get.back();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
