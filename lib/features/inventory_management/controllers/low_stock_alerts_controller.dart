import 'package:get/get.dart';
import '../models/low_stock_model.dart';

class LowStockAlertsController extends GetxController {
  final RxList<LowStockItem> lowStockItems = <LowStockItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    isLoading.value = true;
    
    // Dummy data for testing
    lowStockItems.value = [
      LowStockItem(
        id: '1',
        name: 'Paracetamol 500mg',
        currentStock: 20,
        minimumThreshold: 100,
        category: 'Pain Relief',
        supplier: 'PharmaCo Ltd',
        lastRestocked: DateTime(2025, 1, 1),
        price: 5.99,
      ),
      LowStockItem(
        id: '2',
        name: 'Amoxicillin 250mg',
        currentStock: 15,
        minimumThreshold: 50,
        category: 'Antibiotics',
        supplier: 'MediSupply Inc',
        lastRestocked: DateTime(2024, 12, 28),
        price: 12.50,
      ),
      LowStockItem(
        id: '3',
        name: 'Insulin Regular',
        currentStock: 5,
        minimumThreshold: 30,
        category: 'Diabetes',
        supplier: 'BioMed Solutions',
        lastRestocked: DateTime(2024, 12, 30),
        price: 45.00,
      ),
      LowStockItem(
        id: '4',
        name: 'Vitamin C 1000mg',
        currentStock: 25,
        minimumThreshold: 75,
        category: 'Vitamins',
        supplier: 'NutriHealth Corp',
        lastRestocked: DateTime(2025, 1, 5),
        price: 8.99,
      ),
      LowStockItem(
        id: '5',
        name: 'Omeprazole 20mg',
        currentStock: 10,
        minimumThreshold: 40,
        category: 'Gastrointestinal',
        supplier: 'PharmaCo Ltd',
        lastRestocked: DateTime(2024, 12, 25),
        price: 15.75,
      ),
    ];
    
    isLoading.value = false;
  }

  List<LowStockItem> get criticalItems => 
      lowStockItems.where((item) => item.isVeryLow).toList();

  List<LowStockItem> get needsReorderItems =>
      lowStockItems.where((item) => item.needsReorder).toList();

  void refreshData() {
    loadDummyData();
  }
}
