<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sale_order_model.dart';
import '../../widgets/order_item_widget.dart';

enum SalesHistoryFilter { all, pending, overdue, today, thisMonth }

class SalesHistoryScreen extends StatelessWidget {
=======
// lib/screens/sales/sales_history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/sale_order_model.dart';
import '../../providers/sales_provider.dart';
import '../../widgets/order_item_widget.dart';

// Enum para definir os possíveis filtros
enum SalesHistoryFilter { all, pending, overdue }

class SalesHistoryScreen extends StatelessWidget {
  // 1. Adicionamos um filtro opcional no construtor
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
  final SalesHistoryFilter filter;

  const SalesHistoryScreen({super.key, this.filter = SalesHistoryFilter.all});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    Query query = FirebaseFirestore.instance.collection('sales');
    String screenTitle;
    final now = DateTime.now();

    switch (filter) {
      case SalesHistoryFilter.pending:
        query = query.where('isPaid', isEqualTo: false);
        screenTitle = 'Contas a Receber';
        break;
      case SalesHistoryFilter.overdue:
        query = query
            .where('isPaid', isEqualTo: false)
            .where('dueDate', isLessThan: Timestamp.now());
        screenTitle = 'Contas Vencidas';
        break;
      case SalesHistoryFilter.today:
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        query = query
            .where('date', isGreaterThanOrEqualTo: startOfDay)
            .where('date', isLessThan: endOfDay);
        screenTitle = 'Vendas de Hoje';
        break;
      case SalesHistoryFilter.thisMonth:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 1);
        query = query
            .where('date', isGreaterThanOrEqualTo: startOfMonth)
            .where('date', isLessThan: endOfMonth);
        screenTitle = 'Vendas do Mês';
        break;
      case SalesHistoryFilter.all:
=======
    final salesData = Provider.of<SalesProvider>(context);

    // 2. Filtramos a lista de pedidos com base no filtro recebido
    final List<SaleOrder> filteredOrders;
    String screenTitle;

    switch (filter) {
      case SalesHistoryFilter.pending:
        filteredOrders = salesData.orders.where((order) => !order.isPaid).toList();
        screenTitle = 'Contas a Receber';
        break;
      case SalesHistoryFilter.overdue:
        filteredOrders = salesData.orders.where((order) => !order.isPaid && order.dueDate.isBefore(DateTime.now())).toList();
        screenTitle = 'Contas Vencidas';
        break;
      case SalesHistoryFilter.all:
      default:
        filteredOrders = salesData.orders;
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
        screenTitle = 'Histórico de Vendas';
        break;
    }

<<<<<<< HEAD
    query = query.orderBy('date', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (ctx, salesSnapshot) {
          if (salesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (salesSnapshot.hasError) {
            print('ERRO DETECTADO: ${salesSnapshot.error}');
            return Center(child: Text('Ocorreu um erro ao carregar os dados. Verifique o console.'));
          }
          if (!salesSnapshot.hasData || salesSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma venda encontrada para este filtro.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final salesDocs = salesSnapshot.data!.docs;

          return ListView.builder(
            itemCount: salesDocs.length,
            itemBuilder: (ctx, i) =>
                OrderItemWidget(order: SaleOrder.fromSnapshot(salesDocs[i])),
          );
        },
=======
    return Scaffold(
      appBar: AppBar(
        // 3. O título da tela agora é dinâmico
        title: Text(screenTitle),
      ),
      body: filteredOrders.isEmpty
          ? Center(
        child: Text(
          'Nenhuma venda encontrada para este filtro.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (ctx, i) => OrderItemWidget(order: filteredOrders[i]),
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
      ),
    );
  }
}