import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// O diálogo agora pode receber um cliente existente para edição
class _CustomerDialog extends StatefulWidget {
  final DocumentSnapshot? customer; // Torna o cliente opcional

  const _CustomerDialog({this.customer});

  @override
  _CustomerDialogState createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<_CustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  var _isLoading = false;

  bool get _isEditing => widget.customer != null; // Verifica se estamos editando

  @override
  void initState() {
    super.initState();
    // Se estiver editando, preenche os campos com os dados existentes
    if (_isEditing) {
      final customerData = widget.customer!.data() as Map<String, dynamic>;
      _nameController.text = customerData['name'];
      _phoneController.text = customerData['phone'] ?? '';
    }
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final String name = _nameController.text;
    final String phone = _phoneController.text;

    try {
      if (_isEditing) {
        // --- LÓGICA DE ATUALIZAÇÃO ---
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(widget.customer!.id)
            .update({
          'name': name,
          'phone': phone,
        });
      } else {
        // --- LÓGICA DE CRIAÇÃO (continua a mesma) ---
        await FirebaseFirestore.instance.collection('customers').add({
          'name': name,
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
class ManageCustomersScreen extends StatelessWidget {
  const ManageCustomersScreen({super.key});

  // A função agora pode receber um cliente para edição
  void _showCustomerDialog(BuildContext context, {DocumentSnapshot? customer}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CustomerDialog(customer: customer),
    );
  }

  void _deleteCustomer(BuildContext context, String customerId, String customerName) {
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
              FirebaseFirestore.instance.collection('customers').doc(customerId).delete();
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customers')
                  .orderBy('name')
                  .snapshots(),
              builder: (ctx, customerSnapshot) {
                if (customerSnapshot.hasError) return const Center(child: Text('Ocorreu um erro!'));
                if (customerSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final customerDocs = customerSnapshot.data?.docs ?? [];
                if (customerDocs.isEmpty) return const Center(child: Text('Nenhum cliente cadastrado.'));

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
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
    );
  }
}