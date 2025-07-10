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
  final SalesHistoryFilter filter;

  const SalesHistoryScreen({super.key, this.filter = SalesHistoryFilter.all});

  @override
  Widget build(BuildContext context) {
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
        screenTitle = 'Histórico de Vendas';
        break;
    }

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
      ),
    );
  }
}