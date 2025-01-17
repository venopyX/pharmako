import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_management_controller.dart';
import '../models/notification.dart' as app_notification;
import '../widgets/custom_card.dart';
import '../widgets/animated_loading.dart';
import 'package:timeago/timeago.dart' as timeago;

/// A view for displaying and managing in-app notifications
class NotificationManagementView extends GetView<NotificationManagementController> {
  const NotificationManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Notifications (${controller.unreadCount})')),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: controller.markAllAsRead,
            tooltip: 'Mark all as read',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear_all') {
                controller.clearAll();
              }
            },
            itemBuilder: (context) => [
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
            child: Obx(() {
              if (controller.isLoading.value) {
                return const AnimatedLoading();
              }

              if (controller.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshNotifications,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.filteredNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.filteredNotifications[index];
                    return _buildNotificationCard(notification);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Unread', 'unread'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Inventory', 'inventory'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Sales', 'sales'),
                  const SizedBox(width: 8),
                  _buildFilterChip('System', 'system'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Reports', 'reports'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by',
            onSelected: controller.setSortOrder,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'newest',
                child: Text('Newest first'),
              ),
              const PopupMenuItem(
                value: 'oldest',
                child: Text('Oldest first'),
              ),
              const PopupMenuItem(
                value: 'priority',
                child: Text('Priority'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Obx(() => FilterChip(
          label: Text(label),
          selected: controller.currentFilter.value == value,
          onSelected: (selected) {
            if (selected) {
              controller.setFilter(value);
            }
          },
        ));
  }

  Widget _buildNotificationCard(app_notification.Notification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.removeNotification(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: CustomCard(
        child: InkWell(
          onTap: () => controller.onNotificationTap(notification),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notification.isRead ? null : Colors.blue.withAlpha(13), // 0.05 * 255 ≈ 13
              border: Border(
                left: BorderSide(
                  color: _getPriorityColor(notification.priority),
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getNotificationIcon(notification.type),
                      color: _getNotificationColor(notification.type),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      timeago.format(notification.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(notification.message),
                if (notification.metadata != null) ...[
                  const SizedBox(height: 8),
                  _buildMetadata(notification.metadata!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata(Map<String, dynamic> metadata) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: metadata.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${entry.key}: ${_formatMetadataValue(entry.value)}',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatMetadataValue(dynamic value) {
    if (value is double) {
      return '\$${value.toStringAsFixed(2)}';
    }
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'normal':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'inventory':
        return Icons.inventory;
      case 'sales':
        return Icons.point_of_sale;
      case 'system':
        return Icons.system_update;
      case 'reports':
        return Icons.analytics;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'inventory':
        return Colors.blue;
      case 'sales':
        return Colors.green;
      case 'system':
        return Colors.purple;
      case 'reports':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
