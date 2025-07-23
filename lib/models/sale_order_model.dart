import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cart_provider.dart';
import './customer_model.dart';

class SaleOrder {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;
  final Customer? customer; // <-- Torna o cliente opcional (pode ser nulo)
  final DateTime? dueDate;    // <-- Torna a data de vencimento opcional
  final String? notes;
  final String paymentMethod;
  bool isPaid;

  SaleOrder({
    required this.id,
    required this.amount,
    required this.products,
    required this.date,
    this.customer, // <-- Agora é opcional
    this.dueDate,    // <-- Agora é opcional
    this.notes,
    required this.paymentMethod,
    this.isPaid = false,
  });

  // Construtor que cria um SaleOrder a partir de um documento do Firestore
  factory SaleOrder.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SaleOrder(
      id: doc.id,
      amount: (data['amount'] as num).toDouble(),
      products: (data['products'] as List<dynamic>).map((item) {
        return CartItem(
          id: item['productId'],
          name: item['name'],
          quantity: item['quantity'],
          price: (item['price'] as num).toDouble(),
        );
      }).toList(),
      date: (data['date'] as Timestamp).toDate(),
      // Verifica se existe um cliente antes de criá-lo
      customer: data.containsKey('customerId')
          ? Customer(
        id: data['customerId'],
        name: data['customerName'],
        phone: '',
      )
          : null,
      // Verifica se existe uma data de vencimento antes de convertê-la
      dueDate: data.containsKey('dueDate')
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      notes: data['notes'],
      paymentMethod: data['paymentMethod'] ?? 'N/A',
      isPaid: data['isPaid'],
    );
  }
}