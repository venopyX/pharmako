class ReferenceData {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReferenceData({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ReferenceData.fromJson(Map<String, dynamic> json) {
    return ReferenceData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ReferenceDataSet {
  final List<ReferenceData> categories;
  final List<ReferenceData> units;
  final List<ReferenceData> manufacturers;
  final List<ReferenceData> locations;

  ReferenceDataSet({
    required this.categories,
    required this.units,
    required this.manufacturers,
    required this.locations,
  });
}
