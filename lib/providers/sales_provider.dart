import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/customer_model.dart';
import '../providers/cart_provider.dart';
import './cash_flow_provider.dart';

class SalesProvider with ChangeNotifier {

  Future<void> addOrder({
    required List<CartItem> cartProducts,
    required double total,
    required Customer customer,
    required DateTime dueDate,
    String? notes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado para realizar a venda.');
    }
    final userId = user.uid;
    final firestore = FirebaseFirestore.instance;

    await firestore.runTransaction((transaction) async {
      // FASE 1: LEITURA E VALIDAÇÃO
      final List<Map<String, dynamic>> productsToUpdate = [];
      for (var cartItem in cartProducts) {
        final productDocRef = firestore.collection('users').doc(userId).collection('products').doc(cartItem.id);
        final productSnapshot = await transaction.get(productDocRef);

        if (!productSnapshot.exists) {
          throw Exception('Produto "${cartItem.name}" não encontrado no estoque!');
        }
        final currentQuantity = (productSnapshot.data()!['quantity'] ?? 0) as int;
        if (currentQuantity < cartItem.quantity) {
          throw Exception('Estoque insuficiente para "${cartItem.name}". Disponível: $currentQuantity');
        }

        final newQuantity = currentQuantity - cartItem.quantity;
        productsToUpdate.add({
          'ref': productDocRef,
          'newQuantity': newQuantity,
        });
      }

      // FASE 2: ESCRITA
      for (var productUpdate in productsToUpdate) {
        transaction.update(productUpdate['ref'], {'quantity': productUpdate['newQuantity']});
      }

      final saleDocRef = firestore.collection('users').doc(userId).collection('sales').doc();
      transaction.set(saleDocRef, {
        'amount': total,
        'date': Timestamp.now(),
        'dueDate': Timestamp.fromDate(dueDate),
        'isPaid': false,
        'paymentMethod': 'Fiado',
        'notes': notes ?? '',
        'userId': userId,
        'customerId': customer.id,
        'customerName': customer.name,
        'products': cartProducts.map((cp) => {
          'productId': cp.id,
          'name': cp.name,
          'quantity': cp.quantity,
          'price': cp.price,
        }).toList(),
      });
    });
  }

  Future<void> addInstantSale({
    required List<CartItem> cartProducts,
    required double total,
    required String paymentMethod,
    required CashFlowProvider cashFlow,
    String? notes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado para realizar a venda.');
    }
    final userId = user.uid;
    final firestore = FirebaseFirestore.instance;

    await firestore.runTransaction((transaction) async {
      // FASE 1: LEITURA E VALIDAÇÃO
      final List<Map<String, dynamic>> productsToUpdate = [];
      for (var cartItem in cartProducts) {
        final productDocRef = firestore.collection('users').doc(userId).collection('products').doc(cartItem.id);
        final productSnapshot = await transaction.get(productDocRef);

        if (!productSnapshot.exists) {
          throw Exception('Produto "${cartItem.name}" não encontrado no estoque!');
        }
        final currentQuantity = (productSnapshot.data()!['quantity'] ?? 0) as int;
        if (currentQuantity < cartItem.quantity) {
          throw Exception('Estoque insuficiente para "${cartItem.name}". Disponível: $currentQuantity');
        }

        final newQuantity = currentQuantity - cartItem.quantity;
        productsToUpdate.add({
          'ref': productDocRef,
          'newQuantity': newQuantity
        });
      }

      // FASE 2: ESCRITA
      for (var productUpdate in productsToUpdate) {
        transaction.update(productUpdate['ref'], {'quantity': productUpdate['newQuantity']});
      }

      cashFlow.addIncome(total);

      final saleDocRef = firestore.collection('users').doc(userId).collection('sales').doc();
      transaction.set(saleDocRef, {
        'amount': total,
        'date': Timestamp.now(),
        'isPaid': true,
        'paymentMethod': paymentMethod,
        'notes': notes ?? '',
        'userId': userId,
        'products': cartProducts.map((cp) => {
          'productId': cp.id,
          'name': cp.name,
          'quantity': cp.quantity,
          'price': cp.price,
        }).toList(),
      });
    });
  }

  Future<void> markOrderAsPaid(String orderId, double orderAmount, CashFlowProvider cashFlow) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado para atualizar a venda.');
    }
    final userId = user.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users').doc(userId)
          .collection('sales').doc(orderId).update({
        'isPaid': true,
      });
      cashFlow.addIncome(orderAmount);
      print('Pedido $orderId marcado como pago no Firestore.');
    } catch (error) {
      print('Erro ao marcar como pago: $error');
      throw error;
    }
  }
}