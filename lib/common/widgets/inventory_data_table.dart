import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../../features/inventory_management/models/product_model.dart';

class InventoryDataTable extends StatelessWidget {
  final String title;
  final List<Product> products;
  final String Function(DateTime) formatDate;
  final String Function(double) formatCurrency;
  final Function(String)? onEdit;
  final Function(String)? onSort;
  final int rowsPerPage;
  final Function(int?)? onRowsPerPageChanged;
  final List<DataColumn>? additionalColumns;

  const InventoryDataTable({
    super.key,
    required this.title,
    required this.products,
    required this.formatDate,
    required this.formatCurrency,
    this.onEdit,
    this.onSort,
    this.rowsPerPage = 10,
    this.onRowsPerPageChanged,
    this.additionalColumns,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaginatedDataTable(
              header: Text(title),
              columns: [
                DataColumn(
                  label: const Text('Name'),
                  onSort: (_, __) => onSort?.call('name'),
                ),
                DataColumn(
                  label: const Text('Category'),
                  onSort: (_, __) => onSort?.call('category'),
                ),
                DataColumn(
                  label: const Text('Manufacturer'),
                  onSort: (_, __) => onSort?.call('manufacturer'),
                ),
                DataColumn(
                  label: const Text('Quantity'),
                  numeric: true,
                  onSort: (_, __) => onSort?.call('quantity'),
                ),
                DataColumn(
                  label: const Text('Price'),
                  numeric: true,
                  onSort: (_, __) => onSort?.call('price'),
                ),
                DataColumn(
                  label: const Text('Expiry Date'),
                  onSort: (_, __) => onSort?.call('expiryDate'),
                ),
                if (onEdit != null) const DataColumn(label: Text('Actions')),
                ...?additionalColumns,
              ],
              source: _InventoryDataSource(
                products,
                formatDate,
                formatCurrency,
                onEdit,
                additionalColumns?.length ?? 0,
              ),
              rowsPerPage: rowsPerPage,
              onRowsPerPageChanged: onRowsPerPageChanged,
              showCheckboxColumn: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryDataSource extends DataTableSource {
  final List<Product> products;
  final String Function(DateTime) formatDate;
  final String Function(double) formatCurrency;
  final Function(String)? onEdit;
  final int additionalColumnsCount;

  _InventoryDataSource(
    this.products, 
    this.formatDate, 
    this.formatCurrency, 
    this.onEdit,
    this.additionalColumnsCount,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;
    final product = products[index];
    
    final List<DataCell> cells = [
      DataCell(Text(product.name)),
      DataCell(Text(product.category)),
      DataCell(Text(product.manufacturer)),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${product.quantity} ${product.unit}'),
            if (product.isLowStock)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.warning, color: Colors.orange, size: 16),
              ),
          ],
        ),
      ),
      DataCell(Text(formatCurrency(product.price))),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatDate(product.expiryDate)),
            if (product.isExpiringSoon)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.access_time, color: Colors.red, size: 16),
              ),
          ],
        ),
      ),
    ];

    // Add action column if onEdit is provided
    if (onEdit != null) {
      cells.add(DataCell(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => onEdit!(product.id),
        ),
      ));
    }

    // Add cells for additional columns
    for (int i = 0; i < additionalColumnsCount; i++) {
      if (product.isLowStock) {
        cells.add(DataCell(Text(product.minimumStockLevel.toString())));
        cells.add(DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${product.quantity} / ${product.minimumStockLevel}'),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.warning, color: Colors.orange, size: 16),
              ),
            ],
          ),
        ));
      }
    }

    return DataRow(cells: cells);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
