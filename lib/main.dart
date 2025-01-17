import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'services/activity_log_service.dart';
import 'services/notification_service.dart';
import 'services/settings_service.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'widgets/app_drawer.dart';
import 'bindings/app_drawer_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  Get.put(ActivityLogService());
  Get.put(NotificationService());
  Get.put(SettingsService());
  Get.put(AuthService());

  // Initialize bindings
  AppDrawerBinding().dependencies();

  runApp(const PharmacyApp());
}

/// The main app widget
class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pharmako',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
      builder: (context, child) {
        return Scaffold(
          body: child,
          drawer: const AppDrawer(),
        );
      },
    );
  }
}
