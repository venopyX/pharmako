import '../../features/sales_management/models/sale_model.dart';
import '../../utils/logging/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class SalesRepository {
  final List<Sale> _sales = [];
  Database? _database;

  Future<void> _initDatabase() async {
    if (_database != null) return;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'sales.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sales(
            id TEXT PRIMARY KEY,
            timestamp TEXT,
            totalAmount REAL,
            items TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveSale(Sale sale) async {
    try {
      await _initDatabase();
      
      // Properly serialize the sale items
      final itemsJson = jsonEncode(sale.toJson()['items']);
      
      await _database?.insert(
        'sales',
        {
          'id': sale.id,
          'timestamp': sale.timestamp.toIso8601String(),
          'totalAmount': sale.totalAmount,
          'items': itemsJson,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _sales.add(sale);
      AppLogger.info('Sale saved successfully: ${sale.id}');
    } catch (e) {
      AppLogger.error('Error saving sale: $e');
      rethrow;
    }
  }

  Future<List<Sale>> getAllSales() async {
    try {
      await _initDatabase();
      final List<Map<String, dynamic>> maps = await _database?.query('sales') ?? [];
      
      return maps.map((map) {
        final List<dynamic> itemsJson = jsonDecode(map['items']);
        final items = itemsJson.map((item) => SaleItem(
          productId: item['productId'],
          productName: item['productName'],
          unitPrice: item['unitPrice'],
          quantity: item['quantity'],
        )).toList();

        return Sale(
          id: map['id'],
          timestamp: DateTime.parse(map['timestamp']),
          totalAmount: map['totalAmount'],
          items: items,
        );
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting sales: $e');
      rethrow;
    }
  }

  Future<double> getTotalSales() async {
    try {
      await _initDatabase();
      final result = await _database?.rawQuery(
        'SELECT SUM(totalAmount) as total FROM sales'
      );
      return result?.first['total'] as double? ?? 0.0;
    } catch (e) {
      AppLogger.error('Error calculating total sales: $e');
      rethrow;
    }
  }
}
