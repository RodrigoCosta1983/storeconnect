// lib/models/sale_order_model.dart

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
}