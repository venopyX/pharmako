import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_menu_controller.dart';

class MainMenuView extends GetView<MainMenuController> {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2196F3).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildQuickStats(),
              const SizedBox(height: 24),
              _buildMenuGrid(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Pharmako',
        style: TextStyle(
          color: Color(0xFF2196F3),
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _buildNotificationBadge(),
        const SizedBox(width: 8),
        _buildProfileButton(),
      ],
    );
  }

  Widget _buildNotificationBadge() {
    return Obx(() => Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: const Color(0xFF2196F3),
          onPressed: controller.goToNotifications,
        ),
        if (controller.notifications.value > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFF44336),
                shape: BoxShape.circle,
              ),
              child: Text(
                controller.notifications.value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ));
  }

  Widget _buildProfileButton() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: controller.goToProfile,
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            Obx(() => CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF2196F3),
              child: Text(
                controller.userInitials.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, ${controller.userName.value}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage your pharmacy inventory efficiently',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF757575),
          ),
        ),
      ],
    ));
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search medicines, categories...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Color(0xFF2196F3)),
        ),
        onSubmitted: controller.handleSearch,
      ),
    );
  }

  Widget _buildQuickStats() {
    return Obx(() => Row(
      children: [
        _buildStatCard(
          'Low Stock',
          controller.lowStockCount.value.toString(),
          const Color(0xFFF44336),
          Icons.warning_outlined,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Expiring Soon',
          controller.expiringCount.value.toString(),
          const Color(0xFFFF9800),
          Icons.timer_outlined,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Total Items',
          controller.totalItemsCount.value.toString(),
          const Color(0xFF4CAF50),
          Icons.inventory_2_outlined,
        ),
      ],
    ));
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMenuCard(
          'Inventory',
          'Manage your stock',
          Icons.inventory_2_outlined,
          const Color(0xFF2196F3),
          controller.goToInventory,
        ),
        _buildMenuCard(
          'Sales',
          'Track transactions',
          Icons.point_of_sale_outlined,
          const Color(0xFF4CAF50),
          controller.goToSales,
        ),
        _buildMenuCard(
          'Analytics',
          'View insights',
          Icons.analytics_outlined,
          const Color(0xFF9C27B0),
          controller.goToAnalytics,
        ),
        _buildMenuCard(
          'Orders',
          'Manage purchases',
          Icons.shopping_cart_outlined,
          const Color(0xFFFF9800),
          controller.goToOrders,
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
