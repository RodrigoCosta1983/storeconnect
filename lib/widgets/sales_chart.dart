// lib/widgets/sales_chart.dart (Versão Simplificada para Teste)

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  final Map<int, double> weeklySales;

  const SalesChart({super.key, required this.weeklySales});

  @override
  Widget build(BuildContext context) {
    // Encontra o maior valor de venda para ajustar a altura do gráfico
    double maxSale = 100; // Valor padrão caso não haja vendas
    if (weeklySales.isNotEmpty && weeklySales.values.any((v) => v > 0)) {
      maxSale = weeklySales.values.reduce((a, b) => a > b ? a : b);
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxSale * 1.2,
        // REMOVEMOS A SEÇÃO DE TOQUE (TOOLTIPS) TEMPORARIAMENTE
        // barTouchData: BarTouchData(...),

        // REMOVEMOS OS TÍTULOS TEMPORARIAMENTE
        titlesData: const FlTitlesData(show: false),

        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: List.generate(7, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: weeklySales[index] ?? 0,
                color: Theme.of(context).primaryColor,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}