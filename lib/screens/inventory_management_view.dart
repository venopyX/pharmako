import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../controllers/inventory_management_controller.dart';
import '../widgets/custom_card.dart';
import '../widgets/animated_loading.dart';
import '../widgets/custom_search_bar.dart';
import '../models/inventory_item.dart';
import 'package:intl/intl.dart';

/// A comprehensive view for managing inventory in the pharmacy
/// Combines functionality from add, edit, view stock views and includes
/// additional features for better inventory management
class InventoryManagementView extends GetView<InventoryManagementController> {
  const InventoryManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: TabBarView(
          children: [
            _buildInventoryListView(),
            _buildLowStockView(),
            _buildExpiringItemsView(),
            _buildStockHistoryView(),
          ],
        ),
        floatingActionButton: _buildSpeedDial(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Obx(() => controller.isSearchMode.value
          ? CustomSearchBar(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              onFilterPressed: controller.toggleFilterSheet,
              hintText: 'Search inventory...',
            )
          : const Text('Inventory Management')),
      actions: _buildAppBarActions(),
      bottom: TabBar(
        isScrollable: true,
        tabs: [
          Tab(text: 'All Items'.tr),
          Tab(text: 'Low Stock'.tr),
          Tab(text: 'Expiring Soon'.tr),
          Tab(text: 'History'.tr),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Obx(() => Icon(
              controller.isSearchMode.value ? Icons.close : Icons.search,
            )),
        onPressed: controller.toggleSearchMode,
      ),
      IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () => _showFilterBottomSheet(),
      ),
      PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.file_download),
              title: Text('Export'.tr),
              onTap: () => controller.exportInventory(),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Settings'.tr),
              onTap: () => Get.toNamed('/settings'),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildInventoryListView() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const AnimatedLoading();
      }
      return RefreshIndicator(
        onRefresh: controller.refreshInventory,
        child: CustomScrollView(
          slivers: [
            _buildInventoryStats(),
            _buildInventoryGrid(),
          ],
        ),
      );
    });
  }

  Widget _buildInventoryStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildStatCard(
              'Total Items',
              controller.totalItems.toString(),
              Icons.inventory,
            ),
            _buildStatCard(
              'Low Stock',
              controller.lowStockCount.toString(),
              Icons.warning,
              color: Colors.orange,
            ),
            _buildStatCard(
              'Expiring Soon',
              controller.expiringCount.toString(),
              Icons.access_time,
              color: Colors.red,
            ),
          ].map((widget) => Expanded(child: widget)).toList(),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      {Color? color}) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color ?? Theme.of(Get.context!).primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title.tr),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: Obx(() {
        final items = controller.filteredItems;
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildInventoryCard(items[index]),
            childCount: items.length,
          ),
        );
      }),
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    return CustomCard(
      onTap: () => _showItemDetails(item),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemImage(item),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${item.quantity}',
                  style: TextStyle(
                    color: item.quantity < item.minQuantity
                        ? Colors.red
                        : Colors.grey[600],
                  ),
                ),
                Text(
                  'Expires: ${DateFormat('MMM dd, yyyy').format(item.expiryDate)}',
                  style: TextStyle(
                    color: item.isExpiringSoon ? Colors.red : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(InventoryItem item) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.medication,
              size: 48,
              color: Theme.of(Get.context!).primaryColor,
            ),
          ),
          if (item.isLowStock || item.isExpiringSoon)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.isExpiringSoon ? Colors.red : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.isExpiringSoon ? 'Expiring Soon' : 'Low Stock',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Theme.of(Get.context!).primaryColor,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.red,
      activeForegroundColor: Colors.white,
      buttonSize: const Size(56.0, 56.0),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: 'Add Stock',
          onTap: () => _showAddStockForm(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.remove),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: 'Remove Stock',
          onTap: () => _showRemoveStockForm(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.edit),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          label: 'Adjust Stock',
          onTap: () => _showAdjustStockForm(),
        ),
      ],
    );
  }

  void _showItemDetails(InventoryItem item) {
    Get.bottomSheet(
      ItemDetailsBottomSheet(item: item),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  // TODO: Implement low stock view with filtering and sorting options
  Widget _buildLowStockView() {
    return const Center(child: Text('Low Stock View'));
  }

  // TODO: Implement expiring items view with timeline visualization
  Widget _buildExpiringItemsView() {
    return const Center(child: Text('Expiring Items View'));
  }

  // TODO: Implement stock history view with detailed timeline and filters
  Widget _buildStockHistoryView() {
    return const Center(child: Text('Stock History View'));
  }

  void _showFilterBottomSheet() {
    // TODO: Implement filter bottom sheet
  }

  void _showAddStockForm() {
    // TODO: Implement add stock form
  }

  void _showRemoveStockForm() {
    // TODO: Implement remove stock form
  }

  void _showAdjustStockForm() {
    // TODO: Implement adjust stock form
  }
}

/// Bottom sheet widget for displaying detailed item information
class ItemDetailsBottomSheet extends StatelessWidget {
  final InventoryItem item;

  const ItemDetailsBottomSheet({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: Implement detailed item view with charts and history
        ],
      ),
    );
  }
}
