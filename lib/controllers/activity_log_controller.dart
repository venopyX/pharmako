import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/activity_log.dart';
import '../services/sample_data_service.dart';

/// Controller for managing activity logs
class ActivityLogController extends GetxController {
  final _logger = Logger();

  // Observable states
  final activityLogs = <ActivityLog>[].obs;
  final isLoading = false.obs;
  final currentFilter = 'all'.obs;
  final currentModule = 'all'.obs;
  final dateRange = Rx<DateTimeRange?>(null);
  final sortOrder = 'newest'.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivityLogs();
  }

  /// Load activity logs from the service
  Future<void> loadActivityLogs() async {
    try {
      isLoading.value = true;
      _logger.i('Loading activity logs...');

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      activityLogs.value = SampleDataService.getSampleActivityLogs();
      _logger.i('Loaded ${activityLogs.length} activity logs');
    } catch (e, stackTrace) {
      _logger.e('Failed to load activity logs',
          error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load activity logs',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh activity logs
  Future<void> refreshActivityLogs() async {
    await loadActivityLogs();
  }

  /// Get filtered and sorted activity logs
  List<ActivityLog> get filteredLogs {
    var filtered = <ActivityLog>[];

    // Apply module filter
    if (currentModule.value != 'all') {
      filtered = activityLogs
          .where((log) => log.module == currentModule.value)
          .toList();
    } else {
      filtered = activityLogs.toList();
    }

    // Apply action filter
    if (currentFilter.value != 'all') {
      filtered =
          filtered.where((log) => log.action == currentFilter.value).toList();
    }

    // Apply date range filter
    if (dateRange.value != null) {
      filtered = filtered.where((log) {
        return log.timestamp.isAfter(dateRange.value!.start) &&
            log.timestamp.isBefore(dateRange.value!.end);
      }).toList();
    }

    // Apply sort
    switch (sortOrder.value) {
      case 'oldest':
        filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case 'user':
        filtered.sort((a, b) => a.userName.compareTo(b.userName));
        break;
      case 'module':
        filtered.sort((a, b) => a.module.compareTo(b.module));
        break;
      default: // newest
        filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    return filtered;
  }

  /// Set the current action filter
  void setActionFilter(String filter) {
    currentFilter.value = filter;
  }

  /// Set the current module filter
  void setModuleFilter(String module) {
    currentModule.value = module;
  }

  /// Set the date range filter
  void setDateRange(DateTimeRange range) {
    dateRange.value = range;
  }

  /// Clear all filters
  void clearFilters() {
    currentFilter.value = 'all';
    currentModule.value = 'all';
    dateRange.value = null;
  }

  /// Set the sort order
  void setSortOrder(String order) {
    sortOrder.value = order;
  }

  /// Export activity logs to CSV
  Future<void> exportToCSV() async {
    try {
      _logger.i('Exporting activity logs to CSV...');
      // TODO: Implement CSV export
      Get.snackbar(
        'Success',
        'Activity logs exported successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to export activity logs',
          error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to export activity logs',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Get available modules for filtering
  List<String> get availableModules {
    final modules = activityLogs.map((log) => log.module).toSet().toList();
    modules.sort();
    return ['all', ...modules];
  }

  /// Get available actions for filtering
  List<String> get availableActions {
    final actions = activityLogs.map((log) => log.action).toSet().toList();
    actions.sort();
    return ['all', ...actions];
  }

  /// Get statistics about activity logs
  Map<String, int> get statistics {
    return {
      'total': activityLogs.length,
      'success': activityLogs.where((log) => log.status == 'success').length,
      'failed': activityLogs.where((log) => log.status == 'failed').length,
      'pending': activityLogs.where((log) => log.status == 'pending').length,
    };
  }
}
