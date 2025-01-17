import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/settings_service.dart';
import '../widgets/custom_card.dart';

/// A view for managing application settings
class SettingsView extends GetView<SettingsService> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: controller.resetToDefaults,
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildThemeSettings(),
          const SizedBox(height: 16),
          _buildDisplaySettings(),
          const SizedBox(height: 16),
          _buildInventorySettings(),
          const SizedBox(height: 16),
          _buildSalesSettings(),
          const SizedBox(height: 16),
          _buildBackupSettings(),
          const SizedBox(height: 16),
          _buildSecuritySettings(),
        ],
      ),
    );
  }

  Widget _buildThemeSettings() {
    return Obx(() => CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Theme', Icons.palette),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme throughout the app'),
            value: controller.settings.value.isDarkMode,
            onChanged: (value) => controller.updateTheme(isDarkMode: value),
          ),
          ListTile(
            title: const Text('Primary Color'),
            trailing: _buildColorPicker(),
          ),
          SwitchListTile(
            title: const Text('High Contrast'),
            subtitle: const Text('Increase contrast for better visibility'),
            value: controller.settings.value.highContrastMode,
            onChanged: (value) => controller.updateTheme(highContrastMode: value),
          ),
          SwitchListTile(
            title: const Text('Animations'),
            subtitle: const Text('Enable animations throughout the app'),
            value: controller.settings.value.animationsEnabled,
            onChanged: (value) => controller.updateTheme(animationsEnabled: value),
          ),
        ],
      ),
    ));
  }

  Widget _buildDisplaySettings() {
    return Obx(() => CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Display', Icons.display_settings),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: controller.settings.value.language,
              onChanged: (value) {
                if (value != null) {
                  controller.updateDisplay(language: value);
                }
              },
              items: controller.availableLanguages.map((language) {
                return DropdownMenuItem(
                  value: language['code'],
                  child: Text(language['name']!),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Date Format'),
            trailing: DropdownButton<String>(
              value: controller.settings.value.dateFormat,
              onChanged: (value) {
                if (value != null) {
                  controller.updateDisplay(dateFormat: value);
                }
              },
              items: controller.availableDateFormats.map((format) {
                return DropdownMenuItem(
                  value: format,
                  child: Text(format),
                );
              }).toList(),
            ),
          ),
          SwitchListTile(
            title: const Text('24-Hour Time'),
            subtitle: const Text('Use 24-hour time format'),
            value: controller.settings.value.use24HourFormat,
            onChanged: (value) => controller.updateDisplay(use24HourFormat: value),
          ),
          ListTile(
            title: const Text('Currency'),
            trailing: DropdownButton<String>(
              value: controller.settings.value.currency,
              onChanged: (value) {
                if (value != null) {
                  controller.updateDisplay(currency: value);
                }
              },
              items: controller.availableCurrencies.map((currency) {
                return DropdownMenuItem(
                  value: currency['code'],
                  child: Text('${currency['name']} (${currency['symbol']})'),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Decimal Places'),
            trailing: DropdownButton<int>(
              value: controller.settings.value.decimalPlaces,
              onChanged: (value) {
                if (value != null) {
                  controller.updateDisplay(decimalPlaces: value);
                }
              },
              items: List.generate(4, (i) => i).map((i) {
                return DropdownMenuItem(
                  value: i,
                  child: Text(i.toString()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildInventorySettings() {
    return Obx(() => CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Inventory', Icons.inventory),
          ListTile(
            title: const Text('Low Stock Threshold'),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(
                  text: controller.settings.value.lowStockThreshold.toString(),
                ),
                onSubmitted: (value) {
                  final threshold = int.tryParse(value);
                  if (threshold != null) {
                    controller.updateInventory(lowStockThreshold: threshold);
                  }
                },
              ),
            ),
          ),
          ListTile(
            title: const Text('Expiry Warning Days'),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(
                  text: controller.settings.value.expiryWarningDays.toString(),
                ),
                onSubmitted: (value) {
                  final days = int.tryParse(value);
                  if (days != null) {
                    controller.updateInventory(expiryWarningDays: days);
                  }
                },
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Auto-generate Barcodes'),
            subtitle: const Text('Automatically generate barcodes for new items'),
            value: controller.settings.value.autoGenerateBarcodes,
            onChanged: (value) => controller.updateInventory(autoGenerateBarcodes: value),
          ),
          SwitchListTile(
            title: const Text('Track Batch Numbers'),
            subtitle: const Text('Enable batch number tracking for inventory items'),
            value: controller.settings.value.trackBatchNumbers,
            onChanged: (value) => controller.updateInventory(trackBatchNumbers: value),
          ),
          SwitchListTile(
            title: const Text('Location Tracking'),
            subtitle: const Text('Track physical location of inventory items'),
            value: controller.settings.value.enableLocationTracking,
            onChanged: (value) => controller.updateInventory(enableLocationTracking: value),
          ),
        ],
      ),
    ));
  }

  Widget _buildSalesSettings() {
    return Obx(() => CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Sales', Icons.point_of_sale),
          SwitchListTile(
            title: const Text('Require Customer Info'),
            subtitle: const Text('Require customer information for sales'),
            value: controller.settings.value.requireCustomerInfo,
            onChanged: (value) => controller.updateSales(requireCustomerInfo: value),
          ),
          SwitchListTile(
            title: const Text('Print Receipts'),
            subtitle: const Text('Automatically print receipts for sales'),
            value: controller.settings.value.printReceipts,
            onChanged: (value) => controller.updateSales(printReceipts: value),
          ),
          SwitchListTile(
            title: const Text('Allow Discounts'),
            subtitle: const Text('Enable discount application on sales'),
            value: controller.settings.value.allowDiscounts,
            onChanged: (value) => controller.updateSales(allowDiscounts: value),
          ),
          ListTile(
            title: const Text('Max Discount %'),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(
                  text: controller.settings.value.maxDiscountPercent.toString(),
                ),
                onSubmitted: (value) {
                  final discount = double.tryParse(value);
                  if (discount != null) {
                    controller.updateSales(maxDiscountPercent: discount);
                  }
                },
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Track Sales Person'),
            subtitle: const Text('Track who made each sale'),
            value: controller.settings.value.trackSalesPerson,
            onChanged: (value) => controller.updateSales(trackSalesPerson: value),
          ),
        ],
      ),
    ));
  }

  Widget _buildBackupSettings() {
    return Obx(() => CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Backup', Icons.backup),
          SwitchListTile(
            title: const Text('Auto Backup'),
            subtitle: const Text('Automatically backup data'),
            value: controller.settings.value.autoBackup,
            onChanged: (value) => controller.updateBackup(autoBackup: value),
          ),
          ListTile(
            title: const Text('Backup Frequency (Days)'),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(
                  text: controller.settings.value.backupFrequencyDays.toString(),
                ),
                onSubmitted: (value) {
                  final days = int.tryParse(value);
                  if (days != null) {
                    controller.updateBackup(backupFrequencyDays: days);
                  }
                },
              ),
            ),
          ),
          ListTile(
            title: const Text('Backup Location'),
            subtitle: Text(controller.settings.value.backupLocation),
            trailing: IconButton(
              icon: const Icon(Icons.folder),
              onPressed: () {
                // TODO: Implement folder picker
              },
            ),
          ),
          ListTile(
            title: const Text('Retain Backups (Days)'),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(
                  text: controller.settings.value.retainBackupDays.toString(),
                ),
                onSubmitted: (value) {
                  final days = int.tryParse(value);
                  if (days != null) {
                    controller.updateBackup(retainBackupDays: days);
                  }
                },
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Compress Backups'),
            subtitle: const Text('Compress backup files to save space'),
            value: controller.settings.value.compressBackups,
            onChanged: (value) => controller.updateBackup(compressBackups: value),
          ),
        ],
      ),
    ));
  }

  Widget _buildSecuritySettings() {
    return Obx(() => CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Security', Icons.security),
          ListTile(
            title: const Text('Session Timeout (Minutes)'),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(
                  text: controller.settings.value.sessionTimeoutMinutes.toString(),
                ),
                onSubmitted: (value) {
                  final minutes = int.tryParse(value);
                  if (minutes != null) {
                    controller.updateSecurity(sessionTimeoutMinutes: minutes);
                  }
                },
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Require Password Change'),
            subtitle: const Text('Require periodic password changes'),
            value: controller.settings.value.requirePasswordChange,
            onChanged: (value) => controller.updateSecurity(requirePasswordChange: value),
          ),
          ListTile(
            title: const Text('Password Expiry (Days)'),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(
                  text: controller.settings.value.passwordExpiryDays.toString(),
                ),
                onSubmitted: (value) {
                  final days = int.tryParse(value);
                  if (days != null) {
                    controller.updateSecurity(passwordExpiryDays: days);
                  }
                },
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Two-Factor Authentication'),
            subtitle: const Text('Enable 2FA for enhanced security'),
            value: controller.settings.value.twoFactorAuth,
            onChanged: (value) => controller.updateSecurity(twoFactorAuth: value),
          ),
          SwitchListTile(
            title: const Text('Log Failed Attempts'),
            subtitle: const Text('Log failed login attempts'),
            value: controller.settings.value.logFailedAttempts,
            onChanged: (value) => controller.updateSecurity(logFailedAttempts: value),
          ),
        ],
      ),
    ));
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return PopupMenuButton<String>(
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: controller.availableColors[controller.settings.value.primaryColor],
          shape: BoxShape.circle,
        ),
      ),
      onSelected: (color) => controller.updateTheme(primaryColor: color),
      itemBuilder: (context) => controller.availableColors.entries.map((entry) {
        return PopupMenuItem(
          value: entry.key,
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: entry.value,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(entry.key.capitalize!),
            ],
          ),
        );
      }).toList(),
    );
  }
}
