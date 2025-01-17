import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../controllers/app_drawer_controller.dart';

/// A modern drawer widget for the Pharmako app
class AppDrawer extends GetView<AppDrawerController> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: _buildMenuItems(theme),
          ),
          _buildFooter(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(Get.context!).padding.top + 16,
        bottom: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor,
            theme.primaryColor.withAlpha(200),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Obx(() => CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(controller.userAvatar.value),
                  )),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          controller.userName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          controller.userRole.value,
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 14,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.store_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Obx(() => Text(
                      controller.pharmacyName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildMenuItem(
          icon: Icons.dashboard_outlined,
          title: 'Dashboard',
          onTap: () => Get.toNamed(AppRoutes.dashboard),
          theme: theme,
        ),
        _buildMenuItem(
          icon: Icons.inventory_2_outlined,
          title: 'Inventory',
          onTap: () => Get.toNamed(AppRoutes.inventory),
          theme: theme,
        ),
        _buildMenuItem(
          icon: Icons.point_of_sale_outlined,
          title: 'Sales',
          onTap: () => Get.toNamed(AppRoutes.sales),
          theme: theme,
        ),
        _buildMenuItem(
          icon: Icons.assessment_outlined,
          title: 'Reports',
          onTap: () => Get.toNamed(AppRoutes.reports),
          theme: theme,
        ),
        const Divider(),
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          badge: controller.notifications.value.toString(),
          onTap: () => Get.toNamed(AppRoutes.notifications),
          theme: theme,
        ),
        _buildMenuItem(
          icon: Icons.history_outlined,
          title: 'Activity Log',
          onTap: () => Get.toNamed(AppRoutes.activityLog),
          theme: theme,
        ),
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Profile',
          onTap: () => Get.toNamed(AppRoutes.profile),
          theme: theme,
        ),
        _buildMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () => Get.toNamed(AppRoutes.settings),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? badge,
    required Function() onTap,
    required ThemeData theme,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: theme.primaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () {
        Get.back(); // Close drawer
        onTap();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.help_outline,
              color: theme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Need Help?',
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contact support',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: theme.primaryColor,
            size: 16,
          ),
        ],
      ),
    );
  }
}
