import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 1. Definição do Diálogo como StatefulWidget (com createState)
class _ProductDialog extends StatefulWidget {
  final DocumentSnapshot? product;

  const _ProductDialog({this.product});

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

// 2. Implementação completa do State do Diálogo
class _ProductDialogState extends State<_ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  var _isLoading = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final productData = widget.product!.data() as Map<String, dynamic>;
      _nameController.text = productData['name'];
      _priceController.text = productData['price'].toString();
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final String name = _nameController.text;
    final double price = double.parse(_priceController.text);

    try {
      if (_isEditing) {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.product!.id)
            .update({'name': name,  'name_lowercase': name.toLowerCase(), 'price': price});
      } else {
        await FirebaseFirestore.instance.collection('products').add({
          'name': name,
          'name_lowercase': name.toLowerCase(),
          'price': price,
          'createdAt': Timestamp.now(),
        });
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto salvo com sucesso!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar produto: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Editar Produto' : 'Adicionar Novo Produto'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira um nome.';
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Preço (ex: 10.50)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira um preço.';
                if (double.tryParse(value) == null) return 'Por favor, insira um número válido.';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveProduct,
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Salvar'),
        ),
      ],
    );
  }
}

// 3. A tela principal que agora é um StatefulWidget para a busca
class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showProductDialog(BuildContext context, {DocumentSnapshot? product}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ProductDialog(product: product),
    );
  }

  void _deleteProduct(BuildContext context, String productId, String productName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Você tem certeza que deseja excluir o produto "$productName"?'),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(ctx).pop()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Excluir'),
            onPressed: () {
              FirebaseFirestore.instance.collection('products').doc(productId).delete();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Query query = FirebaseFirestore.instance.collection('products');

    if (_searchQuery.isNotEmpty) {
      final searchQueryLower = _searchQuery.toLowerCase(); // Converte o termo da busca para minúsculas
      query = query
      // Busca no novo campo 'name_lowercase'
          .where('name_lowercase', isGreaterThanOrEqualTo: searchQueryLower)
          .where('name_lowercase', isLessThanOrEqualTo: '$searchQueryLower\uf8ff')
      // Ordena pelo campo de busca para o índice funcionar
          .orderBy('name_lowercase');
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
      Positioned.fill(
      child: Opacity(
      opacity: isDarkMode ? 0.4 : 0.15,
        child: Image.asset(
          isDarkMode
              ? 'assets/backgrounds/background_light.png'
              : 'assets/images/background_dark.jpg',
          fit: BoxFit.cover,
        ),
      ),
    ),
    SafeArea(
    child: Column(
    children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
    controller: _searchController,
    decoration: InputDecoration(
    labelText: 'Buscar por nome...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (ctx, productSnapshot) {
                if (productSnapshot.hasError) return const Center(child: Text('Ocorreu um erro!'));
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final productDocs = productSnapshot.data?.docs ?? [];
                if (productDocs.isEmpty) return const Center(child: Text('Nenhum produto encontrado.'));

                return ListView.builder(
                  itemCount: productDocs.length,
                  itemBuilder: (ctx, index) {
                    final productDocument = productDocs[index];
                    final productData = productDocument.data() as Map<String, dynamic>;
                    final price = productData.containsKey('price') ? productData['price'] as num : 0.0;
                    final productName = productData['name'] ?? 'Nome indisponível';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      child: ListTile(
                        title: Text(productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('R\$ ${price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                              onPressed: () => _showProductDialog(context, product: productDocument),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                              onPressed: () => _deleteProduct(context, productDocument.id, productName),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
    ],
    ),
    ),
        ],
      ),
    );
  }
}