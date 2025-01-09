import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Notifications (${controller.unreadCount})')),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              if (value == 'clear_all') {
                controller.clearAll();
              } else if (value == 'mark_all_read') {
                controller.markAllAsRead();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Text('Mark all as read'),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear all'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.initializeNotifications();
                  },
                  child: ListView.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return _NotificationCard(
                        notification: notification,
                        onTap: () => controller.markAsRead(notification.id),
                        onDismissed: () => controller.removeNotification(notification.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTypeFilter(),
          const SizedBox(width: 8),
          _buildPriorityFilter(),
        ],
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Obx(
      () => DropdownButton<NotificationType?>(
        value: controller.selectedType.isEmpty
            ? null
            : NotificationType.values.firstWhere(
                (e) => e.toString() == controller.selectedType.value,
              ),
        hint: const Text('Filter by type'),
        items: [
          const DropdownMenuItem<NotificationType?>(
            value: null,
            child: Text('All types'),
          ),
          ...NotificationType.values.map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(type.toString().split('.').last),
            ),
          ),
        ],
        onChanged: controller.filterByType,
      ),
    );
  }

  Widget _buildPriorityFilter() {
    return Obx(
      () => DropdownButton<NotificationPriority?>(
        value: controller.selectedPriority.isEmpty
            ? null
            : NotificationPriority.values.firstWhere(
                (e) => e.toString() == controller.selectedPriority.value,
              ),
        hint: const Text('Filter by priority'),
        items: [
          const DropdownMenuItem<NotificationPriority?>(
            value: null,
            child: Text('All priorities'),
          ),
          ...NotificationPriority.values.map(
            (priority) => DropdownMenuItem(
              value: priority,
              child: Text(priority.toString().split('.').last),
            ),
          ),
        ],
        onChanged: controller.filterByPriority,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Notification notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: theme.colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismissed(),
      child: Card(
        elevation: notification.isRead ? 0 : 2,
        color: notification.isRead
            ? theme.colorScheme.surface
            : theme.colorScheme.primaryContainer.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      notification.icon,
                      color: notification.color,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight:
                                  notification.isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeago.format(notification.timestamp),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notification.message,
                  style: theme.textTheme.bodyMedium,
                ),
                if (notification.metadata != null && notification.metadata!.isNotEmpty)
                  _buildMetadataWidget(notification.metadata!, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataWidget(Map<String, dynamic> metadata, ThemeData theme) {
    // Filter out metadata that should be displayed
    final displayableMetadata = Map<String, dynamic>.from(metadata)
      ..removeWhere((key, value) =>
          key == 'type' ||
          value == null ||
          value.toString().isEmpty ||
          value.toString().startsWith('http'));

    if (displayableMetadata.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: displayableMetadata.entries.map((entry) {
          return Chip(
            backgroundColor: theme.colorScheme.surfaceVariant,
            label: Text(
              '${entry.key.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ')}: ${_formatMetadataValue(entry.value)}',
              style: theme.textTheme.bodySmall,
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatMetadataValue(dynamic value) {
    if (value is DateTime || (value is String && value.contains('T'))) {
      try {
        final date = value is DateTime ? value : DateTime.parse(value as String);
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (_) {
        return value.toString();
      }
    }

    if (value is double) {
      return value.toStringAsFixed(2);
    }

    return value.toString();
  }
}
