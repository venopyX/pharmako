import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_profile_management_controller.dart';
import '../services/settings_service.dart';
import '../widgets/custom_card.dart';

/// A comprehensive view for managing user profile and settings
class UserProfileManagementView extends GetView<UserProfileManagementController> {
  const UserProfileManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            _buildProfileTab(context),
            _buildPreferencesTab(),
            _buildSecurityTab(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Profile & Settings'),
      actions: [
        Obx(() {
          if (controller.isEditing.value) {
            return Row(
              children: [
                TextButton(
                  onPressed: controller.cancelEditing,
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: controller.saveProfile,
                  child: const Text('Save'),
                ),
              ],
            );
          }
          return IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.startEditing,
            tooltip: 'Edit Profile',
          );
        }),
      ],
      bottom: const TabBar(
        tabs: [
          Tab(text: 'Profile'),
          Tab(text: 'Preferences'),
          Tab(text: 'Security'),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = controller.currentUser.value;
      if (user == null) {
        return const Center(
          child: Text('Failed to load user profile'),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        // TODO: Implement photo upload
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildProfileSection(
              'Personal Information',
              [
                _buildInfoTile(
                  'Name',
                  user.name,
                  Icons.person,
                  editable: true,
                ),
                _buildInfoTile(
                  'Email',
                  user.email,
                  Icons.email,
                  editable: true,
                ),
                _buildInfoTile(
                  'Role',
                  user.role.toUpperCase(),
                  Icons.work,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileSection(
              'Account Information',
              [
                _buildInfoTile(
                  'Account ID',
                  user.id,
                  Icons.fingerprint,
                ),
                _buildInfoTile(
                  'Created At',
                  _formatDateTime(user.createdAt),
                  Icons.calendar_today,
                ),
                _buildInfoTile(
                  'Last Login',
                  _formatDateTime(user.lastLogin),
                  Icons.access_time,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPreferencesTab() {
    final settingsService = Get.find<SettingsService>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSettingsSection(
            'Display',
            [
              Obx(() => _buildSwitchTile(
                'Dark Mode',
                'Use dark theme throughout the app',
                settingsService.isDarkMode.value,
                (value) => settingsService.updateTheme(isDarkMode: value),
              )),
              ListTile(
                title: const Text('Primary Color'),
                trailing: _buildColorPicker(settingsService),
              ),
              Obx(() => _buildSwitchTile(
                'High Contrast',
                'Increase contrast for better visibility',
                settingsService.displaySettings['highContrastMode'] ?? false,
                (value) {
                  final settings = Map<String, bool>.from(settingsService.displaySettings);
                  settings['highContrastMode'] = value;
                  settingsService.updateDisplaySettings(settings);
                },
              )),
              Obx(() => _buildSwitchTile(
                'Animations',
                'Enable animations throughout the app',
                settingsService.displaySettings['animationsEnabled'] ?? true,
                (value) {
                  final settings = Map<String, bool>.from(settingsService.displaySettings);
                  settings['animationsEnabled'] = value;
                  settingsService.updateDisplaySettings(settings);
                },
              )),
            ],
          ),
          const Divider(),
          _buildSettingsSection(
            'Language & Region',
            [
              Obx(() => ListTile(
                title: const Text('Language'),
                subtitle: Text(settingsService.language.value.toUpperCase()),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (value) => settingsService.updateLanguage(language: value),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    const PopupMenuItem(
                      value: 'es',
                      child: Text('Spanish'),
                    ),
                    const PopupMenuItem(
                      value: 'fr',
                      child: Text('French'),
                    ),
                  ],
                ),
              )),
              Obx(() => _buildSwitchTile(
                '24-Hour Time',
                'Use 24-hour time format',
                settingsService.dateTimeSettings['use24HourFormat'] == 'true',
                (value) {
                  final settings = Map<String, String>.from(settingsService.dateTimeSettings);
                  settings['use24HourFormat'] = value.toString();
                  settingsService.updateDateTimeSettings(settings);
                },
              )),
              Obx(() => ListTile(
                title: const Text('Time Zone'),
                subtitle: Text(settingsService.dateTimeSettings['timeZone'] ?? 'UTC'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Implement time zone selection
                },
              )),
            ],
          ),
          const Divider(),
          _buildSettingsSection(
            'Notifications',
            [
              Obx(() => _buildSwitchTile(
                'Email Notifications',
                'Receive notifications via email',
                settingsService.notificationSettings['email'] ?? true,
                (value) {
                  final settings = Map<String, bool>.from(settingsService.notificationSettings);
                  settings['email'] = value;
                  settingsService.updateNotificationSettings(settings);
                },
              )),
              Obx(() => _buildSwitchTile(
                'Push Notifications',
                'Receive push notifications',
                settingsService.notificationSettings['push'] ?? true,
                (value) {
                  final settings = Map<String, bool>.from(settingsService.notificationSettings);
                  settings['push'] = value;
                  settingsService.updateNotificationSettings(settings);
                },
              )),
              Obx(() => _buildSwitchTile(
                'SMS Notifications',
                'Receive notifications via SMS',
                settingsService.notificationSettings['sms'] ?? false,
                (value) {
                  final settings = Map<String, bool>.from(settingsService.notificationSettings);
                  settings['sms'] = value;
                  settingsService.updateNotificationSettings(settings);
                },
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSettingsSection(
            'Password & Authentication',
            [
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Implement password change
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Two-Factor Authentication'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Implement 2FA setup
                },
              ),
              ListTile(
                leading: const Icon(Icons.devices),
                title: const Text('Active Sessions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Implement session management
                },
              ),
            ],
          ),
          const Divider(),
          _buildSettingsSection(
            'Privacy',
            [
              _buildSwitchTile(
                'Activity Log',
                'Track account activity',
                true,
                (value) {},
              ),
              _buildSwitchTile(
                'Data Collection',
                'Allow anonymous usage data collection',
                false,
                (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon, {
    bool editable = false,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: editable
          ? const Icon(Icons.arrow_forward_ios)
          : null,
      onTap: editable
          ? () {
              // TODO: Implement edit dialog
            }
          : null,
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildColorPicker(SettingsService settingsService) {
    return PopupMenuButton<String>(
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _getColorFromString(settingsService.primaryColor.value),
          shape: BoxShape.circle,
        ),
      ),
      onSelected: (color) => settingsService.updateTheme(primaryColor: color),
      itemBuilder: (context) => [
        _buildColorMenuItem('Blue', Colors.blue),
        _buildColorMenuItem('Red', Colors.red),
        _buildColorMenuItem('Green', Colors.green),
        _buildColorMenuItem('Purple', Colors.purple),
        _buildColorMenuItem('Orange', Colors.orange),
      ],
    );
  }

  PopupMenuItem<String> _buildColorMenuItem(String name, Color color) {
    return PopupMenuItem(
      value: name.toLowerCase(),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(name),
        ],
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
