import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // apenas aumenta a quantidade
      _items.update(
        product.id,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // adiciona um novo item
      _items.putIfAbsent(
        product.id,
            () => CartItem(
          id: DateTime.now().toString(),
          name: product.name,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners(); // Notifica os 'ouvintes' (widgets) que o estado mudou
  }

  // --- NOVO MÉTODO PARA REMOVER UMA UNIDADE ---
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      // Se a quantidade for maior que 1, apenas diminui
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      // Se for 1, remove o item completamente
      _items.remove(productId);
    }
    notifyListeners();
  }

  // --- NOVO MÉTODO PARA ADICIONAR UMA UNIDADE (pelo carrinho) ---
  void addSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    _items.update(
      productId,
          (existingCartItem) => CartItem(
        id: existingCartItem.id,
        name: existingCartItem.name,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
      ),
    );
    notifyListeners();
  }


  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
