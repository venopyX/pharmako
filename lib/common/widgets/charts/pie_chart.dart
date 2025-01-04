// lib/presentation/widgets/charts/pie_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InventoryPieChart extends StatelessWidget {
  final List<MapEntry<String, double>> data;
  final List<Color> colors;

  const InventoryPieChart({
    super.key,
    required this.data,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: List.generate(
                  data.length,
                  (i) {
                    final item = data[i];
                    return PieChartSectionData(
                      color: colors[i % colors.length],
                      value: item.value,
                      title: '${(item.value).toStringAsFixed(1)}%',
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: List.generate(
              data.length,
              (i) {
                final item = data[i];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: colors[i % colors.length],
                    ),
                    const SizedBox(width: 4),
                    Text(item.key),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
