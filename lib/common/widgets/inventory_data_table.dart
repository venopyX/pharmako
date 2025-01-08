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

  const InventoryDataTable({
    super.key,
    required this.title,
    required this.products,
    required this.formatDate,
    required this.formatCurrency,
    required this.totalRows,
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

  _InventoryDataSource(
    this.products,
    this.formatDate,
    this.formatCurrency,
    this.onEdit,
    this.totalRows,
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
        DataCell(Text(product.quantity.toString())),
        DataCell(Text(formatCurrency(product.price))),
        DataCell(Text(formatDate(product.expiryDate))),
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
