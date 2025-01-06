import 'package:intl/intl.dart';
import 'dart:math';

/// Utility class for formatting various types of data
class Formatter {
  static final _currencyFormatter = NumberFormat.currency(symbol: '\$');
  static final _compactCurrencyFormatter =
      NumberFormat.compactCurrency(symbol: '\$');
  static final _numberFormatter = NumberFormat.compact();
  static final _percentFormatter = NumberFormat.percentPattern();
  static final _dateFormatter = DateFormat.yMMMd();
  static final _dateTimeFormatter = DateFormat.yMMMd().add_jm();
  static final _shortDateFormatter = DateFormat.MMMd();
  static final _timeFormatter = DateFormat.jm();

  // Currency Formatting
  static String currency(double value) => _currencyFormatter.format(value);
  static String compactCurrency(double value) =>
      _compactCurrencyFormatter.format(value);

  // Number Formatting
  static String number(num value) => _numberFormatter.format(value);
  static String decimal(double value, {int decimalPlaces = 2}) =>
      NumberFormat.decimalPattern()
          .format(double.parse(value.toStringAsFixed(decimalPlaces)));
  static String percent(double value) => _percentFormatter.format(value / 100);

  // Date Formatting
  static String date(DateTime date) => _dateFormatter.format(date);
  static String dateTime(DateTime date) => _dateTimeFormatter.format(date);
  static String shortDate(DateTime date) => _shortDateFormatter.format(date);
  static String time(DateTime date) => _timeFormatter.format(date);

  // Duration Formatting
  static String duration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  // File Size Formatting
  static String fileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  // Phone Number Formatting
  static String phoneNumber(String number) {
    if (number.length != 10) return number;
    return '(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}';
  }

  // Stock Status Formatting
  static String stockStatus(int quantity, {int lowStockThreshold = 10}) {
    if (quantity <= 0) return 'Out of Stock';
    if (quantity <= lowStockThreshold) return 'Low Stock';
    return 'In Stock';
  }

  // Expiry Status Formatting
  static String expiryStatus(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    } else if (difference.inDays <= 30) {
      return 'Expiring Soon';
    } else if (difference.inDays <= 90) {
      return 'Good';
    } else {
      return 'Excellent';
    }
  }

  // Order Status Formatting
  static String orderStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  // Payment Status Formatting
  static String paymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Payment Pending';
      case 'failed':
        return 'Payment Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }

  // Delivery Status Formatting
  static String deliveryStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
