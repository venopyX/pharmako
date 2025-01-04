import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmako/bindings/general_bindings.dart';
import 'package:pharmako/data/repositories/authentication_repository.dart';
import 'package:pharmako/firebase_options.dart';
import 'package:pharmako/utils/theme/theme.dart';
import 'features/home_dashboard/views/dashboard_view.dart';

Future<void> main() async{
  /// Widget binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Getx local storage
  await GetStorage.init();

  /// Preserve splash until other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    /// Initialize Firebase and Authentication Repository
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((FirebaseApp value) {
      Get.put(AuthenticationRepository());
    });
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: DashboardView(),
    );
  }
}