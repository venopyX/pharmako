import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/view_stock_controller.dart';
import '../models/product_model.dart';
import 'package:intl/intl.dart';

class ViewStockView extends GetView<ViewStockController> {
  const ViewStockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/add-stock'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: controller.searchProducts,
      ),
    );
  }

  Widget _buildFilterChips() {
    final categories = ['All', 'Tablets', 'Syrups', 'Injections', 'Others'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() {
              final isSelected = controller.selectedCategory.value == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  controller.filterByCategory(selected ? category : '');
                },
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No products found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          return _buildProductCard(product);
        },
      );
    });
  }

  Widget _buildProductCard(Product product) {
    final isLowStock = product.isLowStock;
    final isExpiringSoon = product.isExpiringSoon;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.manufacturer,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        // TODO: Implement edit
                        break;
                      case 'delete':
                        controller.deleteProduct(product.id);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  'Quantity: ${product.quantity} ${product.unit}',
                  Icons.inventory,
                  isLowStock ? Colors.red : Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  'Price: \$${product.price}',
                  Icons.attach_money,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip(
                  'Batch: ${product.batchNumber}',
                  Icons.qr_code,
                  Colors.purple,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  'Expires: ${DateFormat('MMM dd, yyyy').format(product.expiryDate)}',
                  Icons.event,
                  isExpiringSoon ? Colors.orange : Colors.grey,
                ),
              ],
            ),
            if (isLowStock || isExpiringSoon) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (isLowStock)
                    const Chip(
                      label: Text('Low Stock'),
                      backgroundColor: Colors.red,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  if (isLowStock && isExpiringSoon)
                    const SizedBox(width: 8),
                  if (isExpiringSoon)
                    const Chip(
                      label: Text('Expiring Soon'),
                      backgroundColor: Colors.orange,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }
}
