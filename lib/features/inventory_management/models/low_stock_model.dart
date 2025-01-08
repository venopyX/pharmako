class LowStockItem {
  final String id;
  final String name;
  final int currentStock;
  final int minimumThreshold;
  final String category;
  final String supplier;
  final DateTime lastRestocked;
  final double price;

  LowStockItem({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.minimumThreshold,
    required this.category,
    required this.supplier,
    required this.lastRestocked,
    required this.price,
  });

  double get stockLevel => (currentStock / minimumThreshold) * 100;
  bool get isVeryLow => stockLevel <= 25;
  bool get needsReorder => currentStock <= minimumThreshold;
}
