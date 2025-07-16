import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Diálogo para Adicionar/Editar Cliente
class _CustomerDialog extends StatefulWidget {
  final DocumentSnapshot? customer;

  const _CustomerDialog({this.customer});

  @override
  _CustomerDialogState createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<_CustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  var _isLoading = false;

  bool get _isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final customerData = widget.customer!.data() as Map<String, dynamic>;
      _nameController.text = customerData['name'];
      _phoneController.text = customerData['phone'] ?? '';
    }
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    final String name = _nameController.text;
    final String phone = _phoneController.text;

    try {
      if (_isEditing) {
        await FirebaseFirestore.instance
            .collection('users').doc(user.uid)
            .collection('customers').doc(widget.customer!.id)
            .update({
          'name': name,
          'name_lowercase': name.toLowerCase(),
          'phone': phone,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users').doc(user.uid)
            .collection('customers').add({
          'name': name,
          'name_lowercase': name.toLowerCase(),
          'phone': phone,
          'createdAt': Timestamp.now(),
        });
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente salvo com sucesso!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar cliente: $error')),
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
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Editar Cliente' : 'Adicionar Novo Cliente'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome do Cliente'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Por favor, insira um nome.';
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefone (opcional)'),
              keyboardType: TextInputType.phone,
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
          onPressed: _isLoading ? null : _saveCustomer,
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Salvar'),
        ),
      ],
    );
  }
}

// A tela principal de gerenciamento de clientes
class ManageCustomersScreen extends StatefulWidget {
  const ManageCustomersScreen({super.key});

  @override
  State<ManageCustomersScreen> createState() => _ManageCustomersScreenState();
}

class _ManageCustomersScreenState extends State<ManageCustomersScreen> {
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

  void _showCustomerDialog(BuildContext context, {DocumentSnapshot? customer}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CustomerDialog(customer: customer),
    );
  }

  void _deleteCustomer(BuildContext context, String customerId, String customerName) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Você tem certeza que deseja excluir o cliente "$customerName"?'),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(ctx).pop()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Excluir'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users').doc(user.uid)
                  .collection('customers').doc(customerId).delete();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(body: Center(child: Text('Erro: Nenhum usuário logado.')));
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Query query = FirebaseFirestore.instance
        .collection('users').doc(user.uid)
        .collection('customers');

    if (_searchQuery.isNotEmpty) {
      final searchQueryLower = _searchQuery.toLowerCase();
      query = query
          .where('name_lowercase', isGreaterThanOrEqualTo: searchQueryLower)
          .where('name_lowercase', isLessThanOrEqualTo: '$searchQueryLower\uf8ff')
          .orderBy('name_lowercase');
    } else {
      query = query.orderBy('name'); // Ordena por nome por padrão
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Gerenciar Clientes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCustomerDialog(context),
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
                      filled: true,
                      fillColor: Theme.of(context).cardColor.withOpacity(0.85),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: query.snapshots(),
                    builder: (ctx, customerSnapshot) {
                      if (customerSnapshot.hasError) return const Center(child: Text('Ocorreu um erro!'));
                      if (customerSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final customerDocs = customerSnapshot.data?.docs ?? [];
                      if (customerDocs.isEmpty) return const Center(child: Text('Nenhum cliente encontrado.'));

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 4),
                        itemCount: customerDocs.length,
                        itemBuilder: (ctx, index) {
                          final customerDocument = customerDocs[index];
                          final customerData = customerDocument.data() as Map<String, dynamic>;
                          final customerName = customerData['name'] ?? 'Nome indisponível';
                          final customerPhone = customerData['phone'] ?? '';

                          return Card(
                            color: Theme.of(context).cardColor.withOpacity(0.9),
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(customerPhone),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                                    onPressed: () => _showCustomerDialog(context, customer: customerDocument),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                                    onPressed: () => _deleteCustomer(context, customerDocument.id, customerName),
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