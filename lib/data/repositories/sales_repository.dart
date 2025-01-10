import '../../features/sales_management/models/sale_model.dart';
import '../../utils/logging/logger.dart';

class SalesRepository {
  final List<Sale> _sales = [];

  Future<void> saveSale(Sale sale) async {
    try {
      _sales.add(sale);
      AppLogger.info('Sale saved successfully: ${sale.id}');
    } catch (e) {
      AppLogger.error('Error saving sale: $e');
      rethrow;
    }
  }

  Future<List<Sale>> getAllSales() async {
    try {
      return List<Sale>.from(_sales);
    } catch (e) {
      AppLogger.error('Error getting sales: $e');
      rethrow;
    }
  }

  Future<double> getTotalSales() async {
    try {
      return _sales.fold<double>(
        0.0,
        (sum, sale) => sum + sale.totalAmount,
      );
    } catch (e) {
      AppLogger.error('Error calculating total sales: $e');
      rethrow;
    }
  }
}
