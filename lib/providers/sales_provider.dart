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
  List<SaleOrder> _orders = [];

  List<SaleOrder> get orders {
    return [..._orders];
  }

  // --- MÉTODO ADDORDER ATUALIZADO ---
  Future<void> addOrder({
    required List<CartItem> cartProducts,
    required double total,
    required Customer customer,
    required DateTime dueDate,
    String? notes,
  }) async {
    // Pega o ID do usuário atualmente logado
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado para realizar a venda.');
    }
    final userId = user.uid;

    try {
      // Adiciona um novo documento na coleção 'sales'
      await FirebaseFirestore.instance
          .collection('users').doc(userId)
          .collection('sales').add({
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado para atualizar a venda.');
    }
    final userId = user.uid;
    try {
      // Encontra o documento da venda na coleção 'sales' e atualiza o campo 'isPaid'
      await FirebaseFirestore.instance
          .collection('users').doc(userId)
          .collection('sales').doc(orderId).update({
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

