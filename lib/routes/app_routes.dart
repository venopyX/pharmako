import 'package:get/get.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/inventory_binding.dart';
import '../bindings/notification_binding.dart';
import '../bindings/expiring_items_binding.dart';
import '../bindings/sales_binding.dart';
import '../bindings/analytics_binding.dart';
import '../bindings/main_menu_binding.dart';
import '../features/home_dashboard/views/dashboard_view.dart';
import '../features/inventory_management/views/add_stock_view.dart';
import '../features/inventory_management/views/edit_stock_view.dart';
import '../features/inventory_management/views/view_stock_view.dart';
import '../features/inventory_management/views/low_stock_view.dart';
import '../features/inventory_management/views/expiring_items_view.dart';
import '../features/alerts_and_notifications/views/notification_view.dart';
import '../features/sales_management/views/sales_view.dart';
import '../features/reports_and_analytics/views/analytics_report_view.dart';
import '../features/main_menu/views/main_menu_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String menu = '/menu';
  static const String reports = '/reports';
  static const String sales = '/sales';
  static const String sale = '/sale';  // Alias for sales for better semantics
  
  static final routes = [
    GetPage(
      name: home,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: menu,
      page: () => const MainMenuView(),
      binding: MainMenuBinding(),
    ),
    GetPage(
      name: reports,
      page: () => const AnalyticsReportView(),
      binding: AnalyticsBinding(),
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
    GetPage(
      name: sales,
      page: () => const SalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: sale,
      page: () => const SalesView(),  // Same view, different route
      binding: SalesBinding(),
    ),
  ];
}
