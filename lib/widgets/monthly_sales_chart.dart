// lib/widgets/monthly_sales_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlySalesChart extends StatelessWidget {
  final Map<int, double> monthlySales; // Espera um mapa com 5 semanas (0 a 4)

  const MonthlySalesChart({super.key, required this.monthlySales});

  @override
  Widget build(BuildContext context) {
    double maxSale = 100;
    if (monthlySales.isNotEmpty && monthlySales.values.any((v) => v > 0)) {
      maxSale = monthlySales.values.reduce((a, b) => a > b ? a : b);
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxSale * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                'Semana ${group.x.toInt() + 1}\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: 'R\$ ${rod.toY.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.yellow[600], fontWeight: FontWeight.w500),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
                String text;
                switch (value.toInt()) {
                  case 0: text = 'S1'; break;
                  case 1: text = 'S2'; break;
                  case 2: text = 'S3'; break;
                  case 3: text = 'S4'; break;
                  case 4: text = 'S5'; break;
                  default: text = ''; break;
                }
                return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
              },
              reservedSize: 38,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: List.generate(5, (index) { // Gera 5 barras para as semanas
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: monthlySales[index] ?? 0,
                color: Theme.of(context).primaryColor,
                width: 22,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}