import '../models/reference_data_model.dart';

class ReferenceDataRepository {
  // Singleton pattern
  static final ReferenceDataRepository _instance = ReferenceDataRepository._internal();
  factory ReferenceDataRepository() => _instance;
  ReferenceDataRepository._internal();

  // Initial data
  final _categories = [
    ReferenceData(
      id: '1',
      name: 'Pain Relief',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '2',
      name: 'Antibiotics',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '3',
      name: 'Diabetes',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '4',
      name: 'Vitamins',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '5',
      name: 'First Aid',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '6',
      name: 'Chronic Care',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '7',
      name: 'Heart Care',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '8',
      name: 'Respiratory Care',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '9',
      name: 'Others',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final _units = [
    ReferenceData(
      id: '1',
      name: 'tablets',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '2',
      name: 'capsules',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '3',
      name: 'vials',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '4',
      name: 'bottles',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '5',
      name: 'strips',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '6',
      name: 'boxes',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '7',
      name: 'tubes',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '8',
      name: 'pieces',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final _manufacturers = [
    ReferenceData(
      id: '1',
      name: 'PharmaCo',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '2',
      name: 'MediPharma',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '3',
      name: 'DiabeCare',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '4',
      name: 'VitaHealth',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '5',
      name: 'Others',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final _locations = [
    ReferenceData(
      id: '1',
      name: 'shelf_a1',
      description: 'Shelf A1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '2',
      name: 'shelf_a2',
      description: 'Shelf A2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '3',
      name: 'shelf_b1',
      description: 'Shelf B1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '4',
      name: 'shelf_b2',
      description: 'Shelf B2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '5',
      name: 'shelf_c1',
      description: 'Shelf C1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '6',
      name: 'shelf_c2',
      description: 'Shelf C2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '7',
      name: 'refrigerator_1',
      description: 'Refrigerator 1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '8',
      name: 'refrigerator_2',
      description: 'Refrigerator 2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ReferenceData(
      id: '9',
      name: 'secure_cabinet',
      description: 'Secure Cabinet',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  // Getters for lists
  Future<List<String>> getCategories() async {
    return _categories.where((c) => c.isActive).map((c) => c.name).toList();
  }

  Future<List<String>> getUnits() async {
    return _units.where((u) => u.isActive).map((u) => u.name).toList();
  }

  Future<List<String>> getManufacturers() async {
    return _manufacturers.where((m) => m.isActive).map((m) => m.name).toList();
  }

  Future<List<String>> getLocations() async {
    return _locations
        .where((l) => l.isActive)
        .map((l) => l.description ?? l.name)
        .toList();
  }

  // Get internal name from display name
  String? getLocationInternalName(String displayName) {
    final location = _locations.firstWhere(
      (l) => l.description == displayName || l.name == displayName,
      orElse: () => ReferenceData(
        id: '0',
        name: displayName.toLowerCase().replaceAll(' ', '_'),
        description: displayName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return location.name;
  }

  // Get display name from internal name
  String? getLocationDisplayName(String internalName) {
    final location = _locations.firstWhere(
      (l) => l.name == internalName,
      orElse: () => ReferenceData(
        id: '0',
        name: internalName,
        description: internalName.split('_')
            .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
            .join(' '),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return location.description ?? location.name;
  }

  // Methods to add new items (to be implemented with persistence later)
  Future<void> addCategory(String name, {String? description}) async {
    final newCategory = ReferenceData(
      id: (_categories.length + 1).toString(),
      name: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _categories.add(newCategory);
  }

  Future<void> addUnit(String name, {String? description}) async {
    final newUnit = ReferenceData(
      id: (_units.length + 1).toString(),
      name: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _units.add(newUnit);
  }

  Future<void> addManufacturer(String name, {String? description}) async {
    final newManufacturer = ReferenceData(
      id: (_manufacturers.length + 1).toString(),
      name: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _manufacturers.add(newManufacturer);
  }

  Future<void> addLocation(String name, {String? description}) async {
    final newLocation = ReferenceData(
      id: (_locations.length + 1).toString(),
      name: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _locations.add(newLocation);
  }
}
