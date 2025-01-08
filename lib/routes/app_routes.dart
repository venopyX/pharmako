import 'package:get/get.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/inventory_binding.dart';
import '../bindings/notification_binding.dart';
import '../bindings/expiring_items_binding.dart';
import '../features/home_dashboard/views/dashboard_view.dart';
import '../features/inventory_management/views/add_stock_view.dart';
import '../features/inventory_management/views/edit_stock_view.dart';
import '../features/inventory_management/views/view_stock_view.dart';
import '../features/inventory_management/views/low_stock_view.dart';
import '../features/inventory_management/views/expiring_items_view.dart';
import '../features/alerts_and_notifications/views/notification_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: '/inventory',
      page: () => const ViewStockView(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: '/add-stock',
      page: () => const AddStockView(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: '/edit-stock',
      page: () => const EditStockView(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: '/low-stock',
      page: () => const LowStockView(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: '/expiring',
      page: () => const ExpiringItemsView(),
      binding: ExpiringItemsBinding(),
    ),
    GetPage(
      name: '/notifications',
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
  ];
}
