// lib/models/sale_order_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/cart_provider.dart'; // Precisamos do CartItem
import './customer_model.dart'; // Precisamos do Cliente

class SaleOrder {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;
  final Customer customer; // Cliente associado à venda
  final DateTime dueDate;    // Data de vencimento
  final String? notes;      // Observações (opcional)
  final String paymentMethod; // "Fiado", "Dinheiro", etc.
  bool isPaid;

  SaleOrder({
    required this.id,
    required this.amount,
    required this.products,
    required this.date,
    required this.customer,
    required this.dueDate,
    this.notes,
    required this.paymentMethod,
    this.isPaid = false,
  });

  // --- NOVO CONSTRUTOR AQUI ---
  // Este construtor cria um SaleOrder a partir de um documento do Firestore
  factory SaleOrder.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SaleOrder(
      id: doc.id,
      amount: (data['amount'] as num).toDouble(),
      // Converte o array de mapas do Firestore de volta para uma lista de CartItem
      products: (data['products'] as List<dynamic>).map((item) {
        return CartItem(
          id: item['productId'],
          name: item['name'],
          quantity: item['quantity'],
          price: (item['price'] as num).toDouble(),
        );
      }).toList(),
      date: (data['date'] as Timestamp).toDate(),
      // Recria um objeto Customer simples com os dados salvos
      customer: Customer(
        id: data['customerId'],
        name: data['customerName'],
        phone: '', // O telefone não é salvo na venda, então fica vazio aqui
      ),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      notes: data['notes'],
      paymentMethod: data['paymentMethod'],
      isPaid: data['isPaid'],
    );
  }
}