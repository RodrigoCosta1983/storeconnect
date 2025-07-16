import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/cash_flow_provider.dart';
import '../../providers/sales_provider.dart';
import '../../widgets/monthly_sales_chart.dart';
import '../../widgets/sales_chart.dart';
import '../sales/sales_history_screen.dart';

// Enum para controlar o período selecionado
enum TimePeriod { day, week, month }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TimePeriod _selectedPeriod = TimePeriod.day;

  // Função para exibir o gráfico semanal
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

  // Função para exibir o gráfico mensal
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

  // Widget para criar os cards de informação
  Widget _buildInfoCard(BuildContext context,
      {required String title,
        required String value,
        required IconData icon,
        Color? color}) {
    // Para a web, damos um tamanho para os cards ficarem uniformes no Wrap
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 4,
        // Cor do card com opacidade para ver o fundo
        color: Theme.of(context).cardColor.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: color ?? Theme.of(context).primaryColor),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<QuerySnapshot>(
      // Usamos um StreamBuilder aqui para que os dados sejam sempre os mais recentes do Firestore
      stream: FirebaseFirestore.instance.collection('sales').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final salesDocs = snapshot.data?.docs ?? [];

        // A lógica de cálculo agora usa os dados do snapshot
        final today = DateTime.now();
        final salesFiltered = salesDocs.where((doc) {
          final orderDate = (doc['date'] as Timestamp).toDate();
          switch (_selectedPeriod) {
            case TimePeriod.day:
              return orderDate.day == today.day && orderDate.month == today.month && orderDate.year == today.year;
            case TimePeriod.week:
              final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
              return orderDate.isAfter(startOfWeek.subtract(const Duration(days: 1)));
            case TimePeriod.month:
              return orderDate.month == today.month && orderDate.year == today.year;
          }
        }).fold(0.0, (sum, doc) => sum + (doc['amount'] as num));

        String salesTitle;
        switch (_selectedPeriod) {
          case TimePeriod.day: salesTitle = 'Vendas de Hoje'; break;
          case TimePeriod.week: salesTitle = 'Vendas da Semana'; break;
          case TimePeriod.month: salesTitle = 'Vendas do Mês'; break;
        }

        final Map<int, double> weeklySalesSummary = {0:0,1:0,2:0,3:0,4:0,5:0,6:0};
        final Map<int, double> monthlySalesSummary = {0:0,1:0,2:0,3:0,4:0};

        final monthlyOrders = salesDocs.where((doc) {
          final orderDate = (doc['date'] as Timestamp).toDate();
          return orderDate.month == today.month && orderDate.year == today.year;
        });

        for (var doc in monthlyOrders) {
          final orderDate = (doc['date'] as Timestamp).toDate();
          final orderAmount = (doc['amount'] as num).toDouble();
          final dayOfWeek = orderDate.weekday;
          weeklySalesSummary.update(dayOfWeek - 1, (value) => value + orderAmount, ifAbsent: () => orderAmount);
          int weekOfMonth = ((orderDate.day - 1) / 7).floor();
          monthlySalesSummary.update(weekOfMonth, (value) => value + orderAmount, ifAbsent: () => orderAmount);
        }

        final pendingFiado = salesDocs.where((doc) => doc['isPaid'] == false).fold(0.0, (sum, doc) => sum + (doc['amount'] as num));
        final overdueCount = salesDocs.where((doc) => doc['isPaid'] == false && (doc['dueDate'] as Timestamp).toDate().isBefore(today)).length;

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
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Dashboard'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: isDarkMode ? 0.4 : 0.15,
                  child: Image.asset(
                    isDarkMode
                        ? 'assets/backgrounds/background_light.png'
                        : 'assets/images/background_dark.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
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
                      const SizedBox(height: 30),
                      Wrap(
                        spacing: 20.0,
                        runSpacing: 20.0,
                        alignment: WrapAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: salesCardOnTap,
                            child: _buildInfoCard(context, title: salesTitle, value: 'R\$ ${salesFiltered.toStringAsFixed(2)}', icon: Icons.point_of_sale),
                          ),
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
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SalesHistoryScreen(filter: SalesHistoryFilter.pending))),
                            child: _buildInfoCard(context, title: 'Contas a Receber (Fiado)', value: 'R\$ ${pendingFiado.toStringAsFixed(2)}', icon: Icons.receipt_long, color: Colors.orange),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SalesHistoryScreen(filter: SalesHistoryFilter.overdue))),
                            child: _buildInfoCard(context, title: 'Contas Vencidas', value: '$overdueCount', icon: Icons.warning_amber_rounded, color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}