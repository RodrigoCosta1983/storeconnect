import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_model/screens/sales/sales_history_screen.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../dashboard/dashboard_screen.dart';
// TODO: Criar a tela do carrinho: import '../cart/cart_screen.dart';

class NewSaleScreen extends StatelessWidget {
  NewSaleScreen({super.key});

  // Dados de exemplo (no futuro, virão de um banco de dados)
  final List<Product> loadedProducts = [
    Product(id: 'p1', name: 'Gelo em Cubo 5kg', price: 10.00, imageUrl: 'assets/images/gelo_saco.jpg'),
    Product(id: 'p2', name: 'Gelo em Cubo 10kg', price: 18.00, imageUrl: 'assets/images/gelo_saco.jpg'),
    Product(id: 'p3', name: 'Barra de Gelo 5kg', price: 12.00, imageUrl: 'assets/images/gelo_barra.jpg'),
    Product(id: 'p4', name: 'Gelo Moído 5kg', price: 11.00, imageUrl: 'assets/images/gelo_saco.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Venda'),
        actions: [
          // Ícone do Carrinho com Badge
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              label: Text(cart.itemCount.toString()),
              isLabelVisible: cart.itemCount > 0,
              child: ch,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // TODO: Navegar para a tela do carrinho
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const CartScreen()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Use a cor primária do seu tema
              ),
              child: Text(
                'Gelo Gestor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const DashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Vendas'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SalesHistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                // TODO: Implementar lógica de logout
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(

        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 colunas
          childAspectRatio: 3 / 4, // Proporção do card
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.antiAlias, // Para cortar a imagem nos cantos arredondados
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  loadedProducts[i].imageUrl,
                  fit: BoxFit.cover,
                  // Em caso de erro ao carregar a imagem
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.ac_unit, size: 50)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  loadedProducts[i].name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'R\$ ${loadedProducts[i].price.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Adicionar'),
                  onPressed: () {
                    // Adiciona o item ao carrinho sem 'ouvir' por atualizações aqui
                    Provider.of<CartProvider>(context, listen: false).addItem(loadedProducts[i]);
                    // Mostra uma confirmação rápida
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    // Mostra a nova SnackBar informativa, que fechará em 2 segundos
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${loadedProducts[i].name} adicionado ao carrinho!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}