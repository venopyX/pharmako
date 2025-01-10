import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_menu_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class MainMenuView extends GetView<MainMenuController> {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmako'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Get.toNamed('/notifications'),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Main Menu',
              style: Get.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.padding),
            _buildMenuGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: AppSizes.padding,
      crossAxisSpacing: AppSizes.padding,
      children: [
        _buildMenuCard(
          'Dashboard',
          Icons.dashboard,
          AppColors.primary,
          () => Get.toNamed('/'),
        ),
        _buildMenuCard(
          'Inventory',
          Icons.inventory_2,
          AppColors.info,
          () => Get.toNamed('/inventory'),
        ),
        _buildMenuCard(
          'Sales',
          Icons.point_of_sale,
          AppColors.success,
          () => Get.toNamed('/sales'),
        ),
        _buildMenuCard(
          'Analytics',
          Icons.analytics,
          AppColors.warning,
          () => Get.toNamed('/analytics'),
          subItems: [
            _buildSubMenuItem(
              'Dashboard Analytics',
              Icons.dashboard,
              () => Get.toNamed('/analytics'),
            ),
            _buildSubMenuItem(
              'Inventory Analytics',
              Icons.inventory_2,
              () => Get.toNamed('/analytics/inventory'),
            ),
            _buildSubMenuItem(
              'Sales Analytics',
              Icons.trending_up,
              () => Get.toNamed('/analytics/sales'),
            ),
            _buildSubMenuItem(
              'Inventory Reports',
              Icons.assessment,
              () => Get.toNamed('/analytics/inventory-report'),
            ),
            _buildSubMenuItem(
              'Customer Analytics',
              Icons.people,
              () => Get.toNamed('/analytics/customers'),
            ),
            _buildSubMenuItem(
              'Order Analytics',
              Icons.shopping_cart,
              () => Get.toNamed('/analytics/orders'),
            ),
          ],
        ),
        _buildMenuCard(
          'Low Stock',
          Icons.warning,
          AppColors.error,
          () => Get.toNamed('/low-stock'),
        ),
        _buildMenuCard(
          'Expiring Items',
          Icons.timer,
          Colors.orange,
          () => Get.toNamed('/expiring'),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    List<Widget>? subItems,
  }) {
    return Card(
      child: InkWell(
        onTap: subItems == null ? onTap : () => _showSubMenu(title, subItems),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 8),
              Text(
                title,
                style: Get.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (subItems != null) ...[
                const SizedBox(height: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: color.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Get.back(); // Close the bottom sheet
        onTap();
      },
    );
  }

  void _showSubMenu(String title, List<Widget> items) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Row(
                children: [
                  Text(
                    title,
                    style: Get.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ...items,
            const SizedBox(height: AppSizes.padding),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
