// lib/screens/cart/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_model/widgets/payment_options_sheet.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart_item_widget.dart';
<<<<<<< HEAD
=======
import '../../widgets/payment_options_sheet.dart';
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765

class CartScreen extends StatelessWidget {
  static const routeName = '/cart'; // Usaremos para navegação futura

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o nosso provider do carrinho
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Carrinho'),
      ),
      body: Column(
        children: <Widget>[
          // Card com o resumo do total
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Total', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Chip(
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // No futuro, este botão levará para a tela de pagamento
                  TextButton(
                    onPressed: () {
                      // Verifica se o carrinho não está vazio
                      if (cart.itemCount == 0) {
                        return; // Não faz nada se não houver itens
                      }
                      // Mostra o painel de opções de pagamento
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder( // Deixa as bordas superiores arredondadas
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (ctx) {
                          return const PaymentOptionsSheet();
                        },
                      );
                    },
                    child: const Text('FINALIZAR VENDA'),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Campo de Observações
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Adicionar observações (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Lista dos itens do carrinho
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItemWidget(
                productId: cart.items.keys.toList()[i],
                title: cartItems[i].name,
                quantity: cartItems[i].quantity,
                price: cartItems[i].price,
              ),
            ),
          )
        ],
      ),
    );
  }
}