// TODO: Define the data model for the dashboard.

class DashboardModel {
  final int totalStock;
  final int lowStock;
  final List<String> alerts;

  DashboardModel({required this.totalStock, required this.lowStock, required this.alerts});
}
