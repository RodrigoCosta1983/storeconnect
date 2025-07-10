// lib/screens/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cash_flow_provider.dart';
import '../../providers/sales_provider.dart';
import '../sales/sales_history_screen.dart';

// Enum para controlar o período selecionado
enum TimePeriod { day, week, month }

// 1. Convertemos para StatefulWidget
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 2. Variável de estado para guardar o período selecionado
  TimePeriod _selectedPeriod = TimePeriod.day;

  // Widget para criar os cards de informação (continua o mesmo)
  Widget _buildInfoCard(BuildContext context, {required String title, required String value, required IconData icon, Color? color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color ?? Theme.of(context).primaryColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final cashFlowProvider = Provider.of<CashFlowProvider>(context);

    // --- LÓGICA ATUALIZADA PARA CALCULAR OS VALORES ---

    // 1. Vendas por Período
    final today = DateTime.now();
    final salesFiltered = salesProvider.orders.where((order) {
      switch (_selectedPeriod) {
        case TimePeriod.day:
          return order.date.day == today.day &&
              order.date.month == today.month &&
              order.date.year == today.year;
        case TimePeriod.week:
          final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
          return order.date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
        case TimePeriod.month:
          return order.date.month == today.month && order.date.year == today.year;
      }
    }).fold(0.0, (sum, order) => sum + order.amount);

    // Título dinâmico para o card de vendas
    String salesTitle;
    switch (_selectedPeriod) {
      case TimePeriod.day:
        salesTitle = 'Vendas de Hoje';
        break;
      case TimePeriod.week:
        salesTitle = 'Vendas da Semana';
        break;
      case TimePeriod.month:
        salesTitle = 'Vendas do Mês';
        break;
    }

    // 2. Contas a Receber (Total pendente)
    final pendingFiado = salesProvider.orders.where((order) => !order.isPaid).fold(0.0, (sum, order) => sum + order.amount);

    // 3. Contas Vencidas
    final overdueCount = salesProvider.orders.where((order) => !order.isPaid && order.dueDate.isBefore(today)).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 3. Seletor de Período
            Center(
              child: ToggleButtons(
                isSelected: [
                  _selectedPeriod == TimePeriod.day,
                  _selectedPeriod == TimePeriod.week,
                  _selectedPeriod == TimePeriod.month,
                ],
                onPressed: (index) {
                  setState(() {
                    if (index == 0) _selectedPeriod = TimePeriod.day;
                    if (index == 1) _selectedPeriod = TimePeriod.week;
                    if (index == 2) _selectedPeriod = TimePeriod.month;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Hoje')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Semana')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Mês')),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card de Vendas com título dinâmico
            _buildInfoCard(
              context,
              title: salesTitle,
              value: 'R\$ ${salesFiltered.toStringAsFixed(2)}',
              icon: Icons.point_of_sale,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Caixa Atual',
              value: 'R\$ ${cashFlowProvider.currentBalance.toStringAsFixed(2)}',
              icon: Icons.wallet_sharp,
              color: Colors.green,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const SalesHistoryScreen(filter: SalesHistoryFilter.pending),
                  ),
                );
              },
              child: _buildInfoCard(
                context,
                title: 'Contas a Receber (Fiado)',
                value: 'R\$ ${pendingFiado.toStringAsFixed(2)}',
                icon: Icons.receipt_long,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            // --- Card de Contas Vencidas clicável ---
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const SalesHistoryScreen(filter: SalesHistoryFilter.overdue),
                  ),
                );
              },
              child: _buildInfoCard(
                context,
                title: 'Contas Vencidas',
                value: '$overdueCount',
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}