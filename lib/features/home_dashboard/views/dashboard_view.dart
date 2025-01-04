import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchDashboardData();
    return Scaffold(
      appBar: AppBar(title: const Text('Home Dashboard')), 
      body: Obx(() {
        final data = controller.dashboardData.value;
        return Column(
          children: [
            Text('Total Stock: ${data.totalStock}'),
            Text('Low Stock: ${data.lowStock}'),
            Expanded(
              child: ListView.builder(
                itemCount: data.alerts.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(data.alerts[index]));
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
