import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

=======
import 'package:tienda_model/screens/sales/sales_history_screen.dart';
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../dashboard/dashboard_screen.dart';
<<<<<<< HEAD
import '../management/manage_customers_screen.dart';
import '../management/manage_products_screen.dart';
import '../sales/sales_history_screen.dart';
import '../login/login_screen.dart';

// 1. Convertido para StatefulWidget
class NewSaleScreen extends StatefulWidget {
  NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  // 2. Lógica e variáveis de estado movidas para a classe State
  String _appVersion = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = info.version;
      });
    }
  }

  // 3. Implementação da função para abrir links
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }
=======
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
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Venda'),
        actions: [
<<<<<<< HEAD
          Consumer<CartProvider>(
            builder: (context, cart, _) => Badge(
              label: Text(cart.itemCount.toString()),
              isLabelVisible: cart.itemCount > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const CartScreen()),
                  );
                },
              ),
=======
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
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
<<<<<<< HEAD
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Gelo Gestor', style: TextStyle(color: Colors.white, fontSize: 24)),
=======
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
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
<<<<<<< HEAD
                Navigator.of(context).pop();
=======
                Navigator.of(context).pop(); // Fecha o drawer
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const DashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Vendas'),
              onTap: () {
<<<<<<< HEAD
                Navigator.of(context).pop();
=======
                Navigator.of(context).pop(); // Fecha o drawer
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SalesHistoryScreen()),
                );
              },
            ),
<<<<<<< HEAD
            const Divider(),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Gerenciar Produtos'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const ManageProductsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gerenciar Clientes'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const ManageCustomersScreen()),
                );
              },
            ),
            const Divider(),
            // 4. Estrutura do item "Sobre" corrigida
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Sobre"),
              onTap: () {
                // --- MUDANÇA AQUI ---
                // 1. Verificamos qual o tema atual ANTES de abrir o diálogo
                final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                // 2. Escolhemos a cor apropriada
                final Color textColor = isDarkMode ? Colors.white70 : Colors.black54;

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Sobre o aplicativo"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Este é um app de gestão para distribuidoras de gelo, desenvolvido por RodrigoCosta-DEV.",
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.link),
                          title: const Text("rodrigocosta-dev.com"),
                          onTap: () => _launchURL('https://rodrigocosta-dev.com'),
                        ),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              'Versão do App: $_appVersion',
                              // 3. Usamos a nossa variável de cor dinâmica
                              style: TextStyle(fontSize: 14, color: textColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Fechar"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],

                  ),
                );
              },
            ),
=======
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
<<<<<<< HEAD
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
=======
                // TODO: Implementar lógica de logout
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
              },
            ),
          ],
        ),
      ),
<<<<<<< HEAD


      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, productSnapshot) {
          if (productSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final productDocs = productSnapshot.data?.docs ?? [];

          if (productDocs.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado. Adicione produtos em "Gerenciar Produtos".'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: productDocs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.15, // Ajuste fino da altura
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) {
              final productData = productDocs[i].data() as Map<String, dynamic>;
              final product = Product(
                id: productDocs[i].id,
                name: productData['name'] ?? 'Produto sem nome',
                price: (productData['price'] as num).toDouble(),
                imageUrl: productData['imageUrl'] ?? '',
              );

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Icon(Icons.ac_unit, size: 50, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4), // Diminuído o padding vertical
                      child: Text(
                        'R\$ ${product.price.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      // --- O BOTÃO COM ÍCONE ESTÁ DE VOLTA ---
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('Adicionar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false).addItem(product);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} adicionado ao carrinho!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
=======
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
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
      ),
    );
  }
}