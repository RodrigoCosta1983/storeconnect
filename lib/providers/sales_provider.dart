// lib/providers/sales_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/abc_product_model.dart'; // Importa o modelo ABC
import '../models/customer_model.dart';
import '../providers/cart_provider.dart';
import './cash_flow_provider.dart';

class SalesProvider with ChangeNotifier {
  // SUAS FUNÇÕES EXISTENTES (addOrder, addInstantSale, markOrderAsPaid)
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
    } catch (error) {
      throw error;
    }
  }

  // --- NOVA FUNÇÃO DE ANÁLISE ABC ---
  Future<List<AbcProduct>> calculateAbcAnalysis({DateTime? startDate}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final firestore = FirebaseFirestore.instance;

    Query salesQuery = firestore.collection('users').doc(user.uid).collection('sales');

    if (startDate != null) {
      salesQuery = salesQuery.where('date', isGreaterThanOrEqualTo: startDate);
    }

    final salesSnapshot = await salesQuery.get();
    if (salesSnapshot.docs.isEmpty) return [];

    final Map<String, AbcProduct> productPerformance = {};
    double totalRevenueAllProducts = 0;

    for (var saleDoc in salesSnapshot.docs) {
      final saleData = saleDoc.data() as Map<String, dynamic>;
      final List<dynamic> items = saleData['products'] ?? [];

      for (var item in items) {
        final productId = item['productId'];
        final productName = item['name'];
        final quantity = item['quantity'] as int;
        final price = item['price'] as num;
        final revenue = quantity * price;

        totalRevenueAllProducts += revenue;

        productPerformance.update(
          productId,
              (existingProduct) {
            existingProduct.totalRevenue += revenue;
            existingProduct.totalQuantity += quantity;
            return existingProduct;
          },
          ifAbsent: () => AbcProduct(
            productId: productId,
            productName: productName,
            totalRevenue: revenue.toDouble(),
            totalQuantity: quantity,
          ),
        );
      }
    }

    if (totalRevenueAllProducts == 0) return [];

    final sortedProducts = productPerformance.values.toList()
      ..sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));

    double cumulativePercentage = 0;
    for (var product in sortedProducts) {
      product.percentageOfTotal = (product.totalRevenue / totalRevenueAllProducts) * 100;
      cumulativePercentage += product.percentageOfTotal;

      if (cumulativePercentage <= 80) {
        product.classification = 'A';
      } else if (cumulativePercentage <= 95) {
        product.classification = 'B';
      } else {
        product.classification = 'C';
      }
    }
    return sortedProducts;
  }
}