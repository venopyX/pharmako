import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

/// Service class for managing application settings
class SettingsService extends GetxService {
  final _logger = Logger();
  static const String _settingsKey = 'app_settings';

  // Theme settings
  final isDarkMode = false.obs;
  final primaryColor = 'blue'.obs;

  // Language settings
  final language = 'en'.obs;

  // Display settings
  final displaySettings = <String, bool>{
    'compactMode': false,
    'highContrastMode': false,
    'animationsEnabled': true,
  }.obs;

  // Date and time settings
  final dateTimeSettings = <String, String>{
    'dateFormat': 'MM/dd/yyyy',
    'use24HourFormat': 'false',
    'timeZone': 'UTC+3',
  }.obs;

  // Currency settings
  final currencySettings = <String, dynamic>{
    'code': 'USD',
  }.obs;

  // Notification settings
  final notificationSettings = <String, bool>{
    'email': true,
    'push': true,
    'sms': false,
  }.obs;

  // Observable settings
  final settings = AppSettings.defaults().obs;

  /// Initialize settings service
  Future<SettingsService> init() async {
    try {
      await loadSettings();
      return this;
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize settings service',
          error: e, stackTrace: stackTrace);
      return this;
    }
  }

  /// Load settings from storage
  Future<void> loadSettings() async {
    try {
      _logger.i('Loading settings...');
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final json = jsonDecode(settingsJson) as Map<String, dynamic>;
        settings.value = AppSettings.fromJson(json);

        // Initialize individual settings
        isDarkMode.value = json['isDarkMode'] ?? false;
        primaryColor.value = json['primaryColor'] ?? 'blue';
        language.value = json['language'] ?? 'en';

        // Initialize display settings
        if (json['displaySettings'] != null) {
          displaySettings.value = Map<String, bool>.from(json['displaySettings']);
        }

        // Initialize date and time settings
        if (json['dateTimeSettings'] != null) {
          dateTimeSettings.value = Map<String, String>.from(json['dateTimeSettings']);
        }

        // Initialize currency settings
        if (json['currencySettings'] != null) {
          currencySettings.value = Map<String, dynamic>.from(json['currencySettings']);
        }

        // Initialize notification settings
        if (json['notificationSettings'] != null) {
          notificationSettings.value = Map<String, bool>.from(json['notificationSettings']);
        }

        _logger.i('Settings loaded successfully');
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load settings', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load settings',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Save settings to storage
  Future<void> saveSettings() async {
    try {
      _logger.i('Saving settings...');
      final prefs = await SharedPreferences.getInstance();
      
      final Map<String, dynamic> json = {
        ...settings.value.toJson(),
        'isDarkMode': isDarkMode.value,
        'primaryColor': primaryColor.value,
        'language': language.value,
        'displaySettings': displaySettings,
        'dateTimeSettings': dateTimeSettings,
        'currencySettings': currencySettings,
        'notificationSettings': notificationSettings,
      };

      await prefs.setString(_settingsKey, jsonEncode(json));
      _logger.i('Settings saved successfully');
    } catch (e, stackTrace) {
      _logger.e('Failed to save settings', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to save settings',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Update theme settings
  Future<void> updateTheme({
    bool? isDarkMode,
    String? primaryColor,
    bool? highContrastMode,
    bool? animationsEnabled,
  }) async {
    settings.value = settings.value.copyWith(
      isDarkMode: isDarkMode,
      primaryColor: primaryColor,
      highContrastMode: highContrastMode,
      animationsEnabled: animationsEnabled,
    );
    await saveSettings();
  }

  /// Update display settings
  Future<void> updateDisplay({
    String? language,
    String? dateFormat,
    bool? use24HourFormat,
    String? currency,
    int? decimalPlaces,
  }) async {
    settings.value = settings.value.copyWith(
      language: language,
      dateFormat: dateFormat,
      use24HourFormat: use24HourFormat,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
    await saveSettings();
  }

  /// Update inventory settings
  Future<void> updateInventory({
    int? lowStockThreshold,
    int? expiryWarningDays,
    bool? autoGenerateBarcodes,
    bool? trackBatchNumbers,
    bool? enableLocationTracking,
  }) async {
    settings.value = settings.value.copyWith(
      lowStockThreshold: lowStockThreshold,
      expiryWarningDays: expiryWarningDays,
      autoGenerateBarcodes: autoGenerateBarcodes,
      trackBatchNumbers: trackBatchNumbers,
      enableLocationTracking: enableLocationTracking,
    );
    await saveSettings();
  }

  /// Update sales settings
  Future<void> updateSales({
    bool? requireCustomerInfo,
    bool? printReceipts,
    bool? allowDiscounts,
    double? maxDiscountPercent,
    bool? trackSalesPerson,
  }) async {
    settings.value = settings.value.copyWith(
      requireCustomerInfo: requireCustomerInfo,
      printReceipts: printReceipts,
      allowDiscounts: allowDiscounts,
      maxDiscountPercent: maxDiscountPercent,
      trackSalesPerson: trackSalesPerson,
    );
    await saveSettings();
  }

  /// Update backup settings
  Future<void> updateBackup({
    bool? autoBackup,
    int? backupFrequencyDays,
    String? backupLocation,
    int? retainBackupDays,
    bool? compressBackups,
  }) async {
    settings.value = settings.value.copyWith(
      autoBackup: autoBackup,
      backupFrequencyDays: backupFrequencyDays,
      backupLocation: backupLocation,
      retainBackupDays: retainBackupDays,
      compressBackups: compressBackups,
    );
    await saveSettings();
  }

  /// Update security settings
  Future<void> updateSecurity({
    int? sessionTimeoutMinutes,
    bool? requirePasswordChange,
    int? passwordExpiryDays,
    bool? twoFactorAuth,
    bool? logFailedAttempts,
  }) async {
    settings.value = settings.value.copyWith(
      sessionTimeoutMinutes: sessionTimeoutMinutes,
      requirePasswordChange: requirePasswordChange,
      passwordExpiryDays: passwordExpiryDays,
      twoFactorAuth: twoFactorAuth,
      logFailedAttempts: logFailedAttempts,
    );
    await saveSettings();
  }

  /// Update display settings
  Future<void> updateDisplaySettings(Map<String, bool> newSettings) async {
    try {
      _logger.i('Updating display settings...');
      displaySettings.value = newSettings;
      await saveSettings();
      _logger.i('Display settings updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Failed to update display settings', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to update display settings',
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Update language settings
  Future<void> updateLanguage({required String language}) async {
    try {
      _logger.i('Updating language to: $language');
      this.language.value = language;
      await saveSettings();
      _logger.i('Language updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Failed to update language', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to update language',
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Update date and time settings
  Future<void> updateDateTimeSettings(Map<String, String> newSettings) async {
    try {
      _logger.i('Updating date and time settings...');
      dateTimeSettings.value = newSettings;
      await saveSettings();
      _logger.i('Date and time settings updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Failed to update date and time settings', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to update date and time settings',
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Update notification settings
  Future<void> updateNotificationSettings(Map<String, bool> newSettings) async {
    try {
      _logger.i('Updating notification settings...');
      notificationSettings.value = newSettings;
      await saveSettings();
      _logger.i('Notification settings updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Failed to update notification settings', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to update notification settings',
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Reset all settings to default values
  Future<void> resetToDefaults() async {
    try {
      _logger.i('Resetting settings to defaults...');
      settings.value = AppSettings.defaults();
      await saveSettings();
      _logger.i('Settings reset to defaults');

      Get.snackbar(
        'Success',
        'Settings reset to defaults',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to reset settings', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to reset settings',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Get available languages
  List<Map<String, String>> get availableLanguages => [
        {'code': 'en', 'name': 'English'},
        {'code': 'es', 'name': 'Spanish'},
        {'code': 'fr', 'name': 'French'},
        {'code': 'de', 'name': 'German'},
        {'code': 'it', 'name': 'Italian'},
      ];

  /// Get available currencies
  List<Map<String, String>> get availableCurrencies => [
        {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
        {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
        {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
        {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
        {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
      ];

  /// Get available date formats
  List<String> get availableDateFormats => [
        'MM/dd/yyyy',
        'dd/MM/yyyy',
        'yyyy-MM-dd',
        'dd.MM.yyyy',
        'yyyy.MM.dd',
      ];

  /// Get available colors
  Map<String, Color> get availableColors => {
        'blue': Colors.blue,
        'red': Colors.red,
        'green': Colors.green,
        'purple': Colors.purple,
        'orange': Colors.orange,
      };
}
