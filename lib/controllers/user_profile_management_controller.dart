import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/user_profile.dart';
import '../services/sample_data_service.dart';
import '../services/settings_service.dart';

/// Controller for managing user profile and settings
class UserProfileManagementController extends GetxController {
  final _logger = Logger();
  final _settingsService = Get.find<SettingsService>();

  // Observable states
  final currentUser = Rx<UserProfile?>(null);
  final isLoading = false.obs;
  final isEditing = false.obs;
  final editableProfile = Rx<UserProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// Load user profile
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      _logger.i('Loading user profile...');

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final profile = SampleDataService.getCurrentUserProfile();
      currentUser.value = profile;
      _logger.i('User profile loaded successfully');

      // Sync settings with user preferences
      _syncSettingsWithPreferences();
    } catch (e, stackTrace) {
      _logger.e('Failed to load user profile',
          error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load user profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Start editing profile
  void startEditing() {
    if (currentUser.value != null) {
      editableProfile.value = currentUser.value;
      isEditing.value = true;
    }
  }

  /// Cancel editing profile
  void cancelEditing() {
    editableProfile.value = null;
    isEditing.value = false;
  }

  /// Save profile changes
  Future<void> saveProfile() async {
    try {
      if (editableProfile.value == null) return;

      _logger.i('Saving user profile...');

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      currentUser.value = editableProfile.value;

      // Sync settings with updated preferences
      _syncSettingsWithPreferences();

      isEditing.value = false;
      editableProfile.value = null;

      _logger.i('User profile saved successfully');
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to save user profile',
          error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to save profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Update user preferences
  Future<void> updatePreferences(Map<String, dynamic> newPreferences) async {
    try {
      if (currentUser.value == null) return;

      _logger.i('Updating user preferences...');

      final updatedProfile = currentUser.value!.copyWith(
        preferences: {
          ...currentUser.value!.preferences,
          ...newPreferences,
        },
      );

      currentUser.value = updatedProfile;

      // Sync settings with updated preferences
      _syncSettingsWithPreferences();

      _logger.i('User preferences updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Failed to update user preferences',
          error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to update preferences',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Sync settings service with user preferences
  void _syncSettingsWithPreferences() {
    if (currentUser.value == null) return;

    final prefs = currentUser.value!.preferences;

    // Sync theme settings
    _settingsService.isDarkMode.value = prefs['theme'] == 'dark';
    _settingsService.primaryColor.value = prefs['primaryColor'] ?? 'blue';

    // Sync language settings
    _settingsService.language.value = prefs['language'] ?? 'en';

    // Sync display settings
    final displaySettings =
        Map<String, bool>.from(_settingsService.displaySettings);
    displaySettings['compactMode'] = prefs['display']['compactMode'] ?? false;
    displaySettings['highContrastMode'] =
        prefs['display']['highContrast'] ?? false;
    displaySettings['animationsEnabled'] =
        prefs['display']['animations'] ?? true;
    _settingsService.displaySettings.value = displaySettings;

    // Sync date and time settings
    final dateTimeSettings =
        Map<String, String>.from(_settingsService.dateTimeSettings);
    dateTimeSettings['dateFormat'] = prefs['dateFormat'] ?? 'MM/dd/yyyy';
    dateTimeSettings['use24HourFormat'] =
        (prefs['timeFormat'] == '24h').toString();
    dateTimeSettings['timeZone'] = prefs['timezone'] ?? 'UTC+3';
    _settingsService.dateTimeSettings.value = dateTimeSettings;

    // Sync currency settings
    final currencySettings =
        Map<String, dynamic>.from(_settingsService.currencySettings);
    currencySettings['code'] = prefs['currency'] ?? 'USD';
    _settingsService.currencySettings.value = currencySettings;

    // Sync notification settings
    final notificationSettings =
        Map<String, bool>.from(_settingsService.notificationSettings);
    notificationSettings['email'] = prefs['notifications']['email'] ?? true;
    notificationSettings['push'] = prefs['notifications']['push'] ?? true;
    notificationSettings['sms'] = prefs['notifications']['sms'] ?? false;
    _settingsService.notificationSettings.value = notificationSettings;
  }

  /// Check if user has specific permission
  bool hasPermission(String permission) {
    return currentUser.value?.permissions[permission] ?? false;
  }

  /// Reset user preferences to defaults
  Future<void> resetPreferences() async {
    try {
      if (currentUser.value == null) return;

      _logger.i('Resetting user preferences...');

      final updatedProfile = currentUser.value!.copyWith(
        preferences: UserProfile.defaultPreferences,
      );

      currentUser.value = updatedProfile;

      // Sync settings with default preferences
      _syncSettingsWithPreferences();

      _logger.i('User preferences reset successfully');
      Get.snackbar(
        'Success',
        'Preferences reset to defaults',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to reset user preferences',
          error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to reset preferences',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
