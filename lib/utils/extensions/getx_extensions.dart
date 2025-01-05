import 'package:get/get.dart';

extension GetExtensions on GetInterface {
  bool get isDevelopmentMode => !const bool.fromEnvironment('dart.vm.product');
}
