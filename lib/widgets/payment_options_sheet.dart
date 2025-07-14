// lib/widgets/payment_options_sheet.dart
<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
=======
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
import 'package:flutter/material.dart';
import 'package:tienda_model/widgets/confirm_fiado_dialog.dart';

import '../models/customer_model.dart';


class PaymentOptionsSheet extends StatelessWidget {
  const PaymentOptionsSheet({super.key});

<<<<<<< HEAD
  void _showCustomerSelectionDialog(BuildContext context) {
=======
  // --- NOVA FUNÇÃO PARA MOSTRAR O DIÁLOGO ---
  void _showCustomerSelectionDialog(BuildContext context) {
    // Dados de exemplo
    final List<Customer> customers = [
      Customer(id: 'c1', name: 'Bar do Zé', phone: '21 99999-1111'),
      Customer(id: 'c2', name: 'Restaurante da Maria', phone: '21 99999-2222'),
      Customer(id: 'c3', name: 'João da Festa', phone: '21 99999-3333'),
    ];

>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Selecionar Cliente'),
<<<<<<< HEAD
          // 2. Usamos um StreamBuilder para buscar os clientes
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('customers').orderBy('name').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhum cliente cadastrado.'));
                }

                final customersDocs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: customersDocs.length,
                  itemBuilder: (context, index) {
                    final customerData = customersDocs[index].data() as Map<String, dynamic>;
                    // 3. Criamos um objeto Customer com os dados do Firestore
                    final customer = Customer(
                      id: customersDocs[index].id,
                      name: customerData['name'] ?? 'Sem nome',
                      phone: customerData['phone'] ?? '',
                    );

                    return ListTile(
                      title: Text(customer.name),
                      onTap: () {
                        Navigator.of(ctx).pop(); // Fecha o diálogo de seleção
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmFiadoDialog(customer: customer),
                        );
                      },
                    );
                  },
                );
              },
=======
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar cliente...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // TODO: Implementar a lógica de busca/filtro na lista
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return ListTile(
                        title: Text(customers[index].name),
                        onTap: () {
                          // TODO: Lógica para confirmar a seleção e a venda fiado
                          print('Cliente selecionado: ${customers[index].name}');
                          Navigator.of(ctx).pop(); // Fecha o dialog
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmFiadoDialog(customer: customer),
                          );// Fecha o painel de pagamento
                        },
                      );
                    },
                  ),
                ),
              ],
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Função para criar um botão de opção de pagamento padronizado
    Widget buildPaymentOption(IconData icon, String label, VoidCallback onTap) {
      return ListTile(
        leading: Icon(icon, size: 30, color: Theme.of(context).primaryColor),
        title: Text(label, style: const TextStyle(fontSize: 18)),
        onTap: onTap,
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Wrap( // Wrap ajusta o conteúdo se não couber na tela
        children: <Widget>[
          const Text(
            'Escolha a forma de pagamento',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          buildPaymentOption(
            Icons.money,
            'Dinheiro',
                () {
              // TODO: Implementar lógica para pagamento em dinheiro
              print('Pagamento em Dinheiro selecionado');
              Navigator.of(context).pop(); // Fecha o painel
            },
          ),
          buildPaymentOption(
            Icons.pix,
            'PIX',
                () {
              // TODO: Implementar lógica para pagamento com PIX
              print('Pagamento com PIX selecionado');
              Navigator.of(context).pop();
            },
          ),
          buildPaymentOption(
            Icons.credit_card,
            'Cartão',
                () {
              // TODO: Implementar lógica para pagamento com Cartão
              print('Pagamento com Cartão selecionado');
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          buildPaymentOption(
            Icons.person_add_alt_1,
            'Fiado / A Prazo',
                () {
              // TODO: Implementar lógica para venda fiado
              // Isso provavelmente abrirá outra tela ou um dialog para selecionar o cliente
             // print('Pagamento Fiado selecionado');
              // Navigator.of(context).pop();
              _showCustomerSelectionDialog(context);

                },
          ),
        ],
      ),
    );
  }
}