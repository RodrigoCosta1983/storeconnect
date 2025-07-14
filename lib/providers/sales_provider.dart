<<<<<<< HEAD
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/sale_order_model.dart';
import '../models/customer_model.dart';
import '../providers/cart_provider.dart';
import './cash_flow_provider.dart';

class SalesProvider with ChangeNotifier {
  // A lista em memória não é mais a nossa fonte principal de dados,
  // mas podemos mantê-la para outros usos ou removê-la no futuro.
  // Por enquanto, não vamos mais adicionar itens a ela.
=======
// lib/providers/sales_provider.dart

import 'package:flutter/foundation.dart';
import '../models/sale_order_model.dart';
import '../models/customer_model.dart';
import '../providers/cart_provider.dart';
import 'cash_flow_provider.dart';

class SalesProvider with ChangeNotifier {
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
  List<SaleOrder> _orders = [];

  List<SaleOrder> get orders {
    return [..._orders];
  }

<<<<<<< HEAD
  // --- MÉTODO ADDORDER ATUALIZADO ---
  Future<void> addOrder({
=======
  void addOrder({
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
    required List<CartItem> cartProducts,
    required double total,
    required Customer customer,
    required DateTime dueDate,
    String? notes,
<<<<<<< HEAD
  }) async {
    // Pega o ID do usuário atualmente logado
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado para realizar a venda.');
    }
    final userId = user.uid;

    try {
      // Adiciona um novo documento na coleção 'sales'
      await FirebaseFirestore.instance.collection('sales').add({
        'amount': total,
        'date': Timestamp.now(), // Firestore usa Timestamp
        'dueDate': Timestamp.fromDate(dueDate),
        'isPaid': false,
        'paymentMethod': 'Fiado',
        'notes': notes ?? '',
        'userId': userId, // Salva quem fez a venda
        'customerId': customer.id, // Salva a referência do cliente
        'customerName': customer.name,
        // Salva a lista de produtos como um array de mapas
        'products': cartProducts.map((cp) => {
          'productId': cp.id,
          'name': cp.name,
          'quantity': cp.quantity,
          'price': cp.price,
        }).toList(),
      });
      // Não precisamos mais do notifyListeners() aqui, pois a tela de histórico
      // lerá os dados diretamente do stream do Firestore.
    } catch (error) {
      print('Erro ao salvar a venda: $error');
      // Re-lança o erro para que a UI possa tratá-lo se necessário
      throw error;
    }
  }

  // --- MÉTODO MARKORDERASPAID ATUALIZADO ---
  Future<void> markOrderAsPaid(String orderId, double orderAmount, CashFlowProvider cashFlow) async {
    try {
      // Encontra o documento da venda na coleção 'sales' e atualiza o campo 'isPaid'
      await FirebaseFirestore.instance.collection('sales').doc(orderId).update({
        'isPaid': true,
      });

      // A lógica do caixa continua a mesma
      cashFlow.addIncome(orderAmount);

      print('Pedido $orderId marcado como pago no Firestore.');
      // Não precisamos do notifyListeners() pelo mesmo motivo de antes.
    } catch (error) {
      print('Erro ao marcar como pago: $error');
      throw error;
    }
  }
}

=======
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
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
