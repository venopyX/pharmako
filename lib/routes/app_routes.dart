import 'package:get/get.dart';
import 'package:pharmako/bindings/dashboard_binding.dart';
import 'package:pharmako/bindings/inventory_binding.dart';
import 'package:pharmako/bindings/main_menu_binding.dart';
import 'package:pharmako/bindings/notification_binding.dart';
import 'package:pharmako/bindings/profile_binding.dart';
import 'package:pharmako/bindings/sales_binding.dart';
import 'package:pharmako/bindings/settings_binding.dart';
import 'package:pharmako/bindings/activity_log_binding.dart';
import 'package:pharmako/bindings/reports_binding.dart';
import 'package:pharmako/screens/activity_log_view.dart';
import 'package:pharmako/screens/dashboard_view.dart';
import 'package:pharmako/screens/inventory_management_view.dart';
import 'package:pharmako/screens/main_menu_view.dart';
import 'package:pharmako/screens/notification_management_view.dart';
import 'package:pharmako/screens/reports_management_view.dart';
import 'package:pharmako/screens/sales_management_view.dart';
import 'package:pharmako/screens/settings_view.dart';
import 'package:pharmako/screens/user_profile_management_view.dart';

/// AppRoutes class handles all the routing configuration for the Pharmako application.
/// It defines route names as constants and provides a list of all available routes
/// with their corresponding screens and bindings.
class AppRoutes {
  /// Private constructor to prevent instantiation
  AppRoutes._();

  // Route names as constants for type safety and easy refactoring
  static const String dashboard = '/dashboard';
  static const String mainMenu = '/main-menu';
  static const String inventory = '/inventory';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String reports = '/reports';
  static const String sales = '/sales';
  static const String activityLog = '/activity-log';

  /// List of all available routes in the application
  static final List<GetPage> routes = [
    GetPage(
      name: dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: mainMenu,
      page: () => const MainMenuView(),
      binding: MainMenuBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: inventory,
      page: () => const InventoryManagementView(),
      binding: InventoryBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profile,
      page: () => const UserProfileManagementView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: notifications,
      page: () => const NotificationManagementView(),
      binding: NotificationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: reports,
      page: () => const ReportsManagementView(),
      binding: ReportsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: sales,
      page: () => const SalesManagementView(),
      binding: SalesBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: activityLog,
      page: () => const ActivityLogView(),
      binding: ActivityLogBinding(),
      transition: Transition.fadeIn,
    ),
  ];

  /// Initial route of the application
  static String get initial => dashboard;
}
