import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_log_controller.dart';
import '../models/activity_log.dart';
import '../widgets/custom_card.dart';
import '../widgets/animated_loading.dart';
import 'package:timeago/timeago.dart' as timeago;

/// A view for displaying activity logs
class ActivityLogView extends GetView<ActivityLogController> {
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: controller.exportToCSV,
            tooltip: 'Export to CSV',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter logs',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatistics(),
          _buildFilters(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const AnimatedLoading();
              }

              if (controller.filteredLogs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No activity logs found',
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
                onRefresh: controller.refreshActivityLogs,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = controller.filteredLogs[index];
                    return _buildLogCard(log);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Obx(() {
      final stats = controller.statistics;
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total',
                stats['total'].toString(),
                Icons.history,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Success',
                stats['success'].toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Failed',
                stats['failed'].toString(),
                Icons.error,
                Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Pending',
                stats['pending'].toString(),
                Icons.pending,
                Colors.orange,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
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
              child: Obx(() => Row(
                children: controller.availableModules.map((module) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(module.toUpperCase()),
                      selected: controller.currentModule.value == module,
                      onSelected: (selected) {
                        if (selected) {
                          controller.setModuleFilter(module);
                        }
                      },
                    ),
                  );
                }).toList(),
              )),
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
                value: 'user',
                child: Text('By user'),
              ),
              const PopupMenuItem(
                value: 'module',
                child: Text('By module'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(ActivityLog log) {
    return CustomCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  log.actionIcon,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${log.userName} • ${log.module.toUpperCase()}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(log.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    log.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(log.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (log.details != null) ...[
              const SizedBox(height: 8),
              _buildDetails(log.details!),
            ],
            const SizedBox(height: 8),
            Text(
              timeago.format(log.timestamp),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(Map<String, dynamic> details) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: details.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${entry.key}: ${_formatDetailValue(entry.value)}',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDetailValue(dynamic value) {
    if (value is double) {
      return '\$${value.toStringAsFixed(2)}';
    }
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Logs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionFilter(),
            const SizedBox(height: 16),
            _buildDateRangeFilter(context),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearFilters();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Action'),
        const SizedBox(height: 8),
        Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.availableActions.map((action) {
            return FilterChip(
              label: Text(action.toUpperCase()),
              selected: controller.currentFilter.value == action,
              onSelected: (selected) {
                if (selected) {
                  controller.setActionFilter(action);
                }
              },
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildDateRangeFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date Range'),
        const SizedBox(height: 8),
        Obx(() => OutlinedButton(
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2025),
              initialDateRange: controller.dateRange.value,
            );
            if (range != null) {
              controller.setDateRange(range);
            }
          },
          child: Text(
            controller.dateRange.value == null
                ? 'Select Date Range'
                : '${_formatDate(controller.dateRange.value!.start)} - '
                  '${_formatDate(controller.dateRange.value!.end)}',
          ),
        )),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
           '${date.day.toString().padLeft(2, '0')}';
  }
}
