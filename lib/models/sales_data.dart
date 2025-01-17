/// Model class representing sales data for charts
class SalesData {
  final String label;
  final double value;

  /// Creates a new sales data instance
  const SalesData({
    required this.label,
    required this.value,
  });

  /// Creates a copy of this sales data with the given fields replaced with new values
  SalesData copyWith({
    String? label,
    double? value,
  }) {
    return SalesData(
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }

  /// Converts this sales data to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }

  /// Creates a sales data from a JSON map
  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      label: json['label'] as String,
      value: json['value'] as double,
    );
  }
}
