import 'package:get/get.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/inventory_binding.dart';
import '../features/home_dashboard/views/dashboard_view.dart';
import '../features/inventory_management/views/add_stock_view.dart';
import '../features/inventory_management/views/edit_stock_view.dart';
import '../features/inventory_management/views/view_stock_view.dart';

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
  ];
}
