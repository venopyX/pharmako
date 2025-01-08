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
  final int totalRows;
  final Function(int)? onPageChanged;
  final int currentPage;
  final bool Function(Product) isLowStock;
  final bool Function(Product) isExpiringSoon;
  final bool Function(Product) isExpired;

  const InventoryDataTable({
    super.key,
    required this.title,
    required this.products,
    required this.formatDate,
    required this.formatCurrency,
    required this.totalRows,
    required this.isLowStock,
    required this.isExpiringSoon,
    required this.isExpired,
    this.onEdit,
    this.onSort,
    this.rowsPerPage = 10,
    this.onRowsPerPageChanged,
    this.onPageChanged,
    this.currentPage = 0,
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
              showFirstLastButtons: true,
              showCheckboxColumn: false,
              onPageChanged: onPageChanged,
              availableRowsPerPage: const [10, 20, 50, 100],
              rowsPerPage: rowsPerPage,
              onRowsPerPageChanged: onRowsPerPageChanged,
              initialFirstRowIndex: currentPage * rowsPerPage,
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
              ],
              source: _InventoryDataSource(
                products,
                formatDate,
                formatCurrency,
                onEdit,
                totalRows,
                isLowStock,
                isExpiringSoon,
                isExpired,
              ),
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
  final int totalRows;
  final bool Function(Product) isLowStock;
  final bool Function(Product) isExpiringSoon;
  final bool Function(Product) isExpired;

  _InventoryDataSource(
    this.products,
    this.formatDate,
    this.formatCurrency,
    this.onEdit,
    this.totalRows,
    this.isLowStock,
    this.isExpiringSoon,
    this.isExpired,
  );

  @override
  DataRow getRow(int index) {
    if (index >= products.length) {
      throw IndexError(index, products);
    }
    final product = products[index];
    return DataRow(
      cells: [
        DataCell(Text(product.name)),
        DataCell(Text(product.category)),
        DataCell(Text(product.manufacturer)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(product.quantity.toString()),
              if (isLowStock(product))
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
              if (isExpired(product) || isExpiringSoon(product))
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    isExpired(product) ? Icons.error_outline : Icons.warning_amber_rounded,
                    color: isExpired(product) ? Colors.red : Colors.orange,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
        if (onEdit != null)
          DataCell(
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEdit!(product.id),
            ),
          ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalRows;

  @override
  int get selectedRowCount => 0;
}
