import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../dashboard/dashboard_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Venda'),
        actions: [
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
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Gelo Gestor', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const DashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Vendas'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SalesHistoryScreen()),
                );
              },
            ),
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),


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
      ),
    );
  }
}