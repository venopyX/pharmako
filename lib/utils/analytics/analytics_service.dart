import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsException implements Exception {
  final String message;

  AnalyticsException({required this.message});

  @override
  String toString() {
    return 'AnalyticsException: $message';
  }
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      throw AnalyticsException(message: 'Failed to log screen view');
    }
  }

  Future<void> logInventoryAction({
    required String action,
    required String productId,
    required String productName,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'inventory_action',
        parameters: {
          'action': action,
          'product_id': productId,
          'product_name': productName,
          ...?additionalParams,
        },
      );
    } catch (e) {
      throw AnalyticsException(message: 'Failed to log inventory action');
    }
  }

  Future<void> logSaleComplete({
    required String saleId,
    required double value,
    required String currency,
    required List<String> items,
  }) async {
    try {
      await _analytics.logPurchase(
        currency: currency,
        value: value,
        items: items
            .map((item) => AnalyticsEventItem(
                  itemId: item,
                  itemName: item,
                ))
            .toList(),
      );
    } catch (e) {
      throw AnalyticsException(message: 'Failed to log sale completion');
    }
  }
}
