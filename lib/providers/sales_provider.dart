// lib/providers/sales_provider.dart

import 'package:flutter/foundation.dart';
import '../models/sale_order_model.dart';
import '../models/customer_model.dart';
import '../providers/cart_provider.dart';
import 'cash_flow_provider.dart';

class SalesProvider with ChangeNotifier {
  List<SaleOrder> _orders = [];

  List<SaleOrder> get orders {
    return [..._orders];
  }

  void addOrder({
    required List<CartItem> cartProducts,
    required double total,
    required Customer customer,
    required DateTime dueDate,
    String? notes,
  }) {
    final newOrder = SaleOrder(
      id: DateTime.now().toString(),
      amount: total,
      products: cartProducts,
      date: DateTime.now(),
      customer: customer,
      dueDate: dueDate,
      notes: notes,
      paymentMethod: 'Fiado', // Por enquanto, focamos no fiado
      isPaid: false,
    );
    _orders.insert(0, newOrder); // Adiciona no início da lista
    notifyListeners();
  }
  void markOrderAsPaid(String orderId, CashFlowProvider cashFlow) {
    // Encontra o índice do pedido na lista
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      // Marca como pago
      _orders[orderIndex].isPaid = true;

      // Adiciona o valor ao caixa
      cashFlow.addIncome(_orders[orderIndex].amount);

      // Notifica a UI para reconstruir
      notifyListeners();
      print('Pedido $orderId marcado como pago e R\$${_orders[orderIndex].amount} adicionado ao caixa.');
    }
  }
}