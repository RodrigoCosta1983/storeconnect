import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sale_order_model.dart';
import '../../widgets/order_item_widget.dart';

enum SalesHistoryFilter { all, pending, overdue, today, thisMonth }

class SalesHistoryScreen extends StatelessWidget {
  final SalesHistoryFilter filter;

  const SalesHistoryScreen({super.key, this.filter = SalesHistoryFilter.all});

  @override
  Widget build(BuildContext context) {
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
        screenTitle = 'Histórico de Vendas';
        break;
    }

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
      ),
    );
  }
}