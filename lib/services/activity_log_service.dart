import 'package:get/get.dart';

/// Service for logging user activities
class ActivityLogService extends GetxService {
  /// Log an activity
  void log(String message) {
    // TODO: Implement logging to backend
    print('LOG: $message');
  }

  /// Log an error
  void logError(String error) {
    // TODO: Implement error logging to backend
    print('ERROR: $error');
  }
}
