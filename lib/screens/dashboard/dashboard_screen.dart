import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cash_flow_provider.dart';
import '../../providers/sales_provider.dart';
import '../../widgets/monthly_sales_chart.dart';
import '../../widgets/sales_chart.dart';
import '../sales/sales_history_screen.dart';

enum TimePeriod { day, week, month }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TimePeriod _selectedPeriod = TimePeriod.day;

  void _showWeeklySalesChartDialog(Map<int, double> weeklySalesData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vendas da Semana'),
        content: SizedBox(
            height: 300,
            width: 400,
            child: SalesChart(weeklySales: weeklySalesData)),
        actions: [
          TextButton(
            child: const Text('Fechar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _showMonthlySalesChartDialog(Map<int, double> monthlySalesData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vendas do Mês (por Semana)'),
        content: SizedBox(
            height: 300,
            width: 400,
            child: MonthlySalesChart(monthlySales: monthlySalesData)),
        actions: [
          TextButton(
            child: const Text('Fechar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title,
        required String value,
        required IconData icon,
        Color? color}) {
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
    // Note: Não precisamos mais do cashFlowProvider aqui em cima

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

    final Map<int, double> weeklySalesSummary = {0:0,1:0,2:0,3:0,4:0,5:0,6:0};
    final Map<int, double> monthlySalesSummary = {0:0,1:0,2:0,3:0,4:0};
    final monthlyOrders = salesProvider.orders.where((order) => order.date.month == today.month && order.date.year == today.year);

    for (var order in monthlyOrders) {
      final dayOfWeek = order.date.weekday;
      weeklySalesSummary.update(dayOfWeek - 1, (value) => value + order.amount, ifAbsent: () => order.amount);
      int weekOfMonth = ((order.date.day - 1) / 7).floor();
      monthlySalesSummary.update(weekOfMonth, (value) => value + order.amount, ifAbsent: () => order.amount);
    }

    final pendingFiado = salesProvider.orders.where((order) => !order.isPaid).fold(0.0, (sum, order) => sum + order.amount);
    final overdueCount = salesProvider.orders.where((order) => !order.isPaid && order.dueDate.isBefore(today)).length;

    VoidCallback? salesCardOnTap;
    switch (_selectedPeriod) {
      case TimePeriod.week:
        salesCardOnTap = () => _showWeeklySalesChartDialog(weeklySalesSummary);
        break;
      case TimePeriod.month:
        salesCardOnTap = () => _showMonthlySalesChartDialog(monthlySalesSummary);
        break;
      case TimePeriod.day:
        salesCardOnTap = () => Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => const SalesHistoryScreen(filter: SalesHistoryFilter.today),
        ));
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: ToggleButtons(
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
            )),
            const SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: salesCardOnTap,
              child: _buildInfoCard(context, title: salesTitle, value: 'R\$ ${salesFiltered.toStringAsFixed(2)}', icon: Icons.point_of_sale),
            ),
            const SizedBox(height: 16),

            // --- CORREÇÃO AQUI: Usando o Consumer ---
            Consumer<CashFlowProvider>(
              builder: (context, cashFlowData, child) {
                return _buildInfoCard(
                  context,
                  title: 'Caixa Atual',
                  value: 'R\$ ${cashFlowData.currentBalance.toStringAsFixed(2)}',
                  icon: Icons.wallet_sharp,
                  color: Colors.green,
                );
              },
            ),
            // --- FIM DA CORREÇÃO ---

            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SalesHistoryScreen(filter: SalesHistoryFilter.pending))),
              child: _buildInfoCard(context, title: 'Contas a Receber (Fiado)', value: 'R\$ ${pendingFiado.toStringAsFixed(2)}', icon: Icons.receipt_long, color: Colors.orange),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SalesHistoryScreen(filter: SalesHistoryFilter.overdue))),
              child: _buildInfoCard(context, title: 'Contas Vencidas', value: '$overdueCount', icon: Icons.warning_amber_rounded, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}