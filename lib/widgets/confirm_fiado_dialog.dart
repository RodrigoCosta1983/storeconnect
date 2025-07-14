// lib/widgets/confirm_fiado_dialog.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pacote para formatar a data
import 'package:provider/provider.dart';
import '../models/customer_model.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_provider.dart';

class ConfirmFiadoDialog extends StatefulWidget {
  final Customer customer;

  const ConfirmFiadoDialog({
    super.key,
    required this.customer,
  });

  @override
  State<ConfirmFiadoDialog> createState() => _ConfirmFiadoDialogState();
}

class _ConfirmFiadoDialogState extends State<ConfirmFiadoDialog> {
  DateTime? _selectedDate;

  // Função que abre o calendário nativo do celular
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Não permite selecionar datas passadas
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return; // Usuário cancelou
      }
      setState(() {
        _selectedDate = pickedDate; // Armazena a data selecionada
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o carrinho para pegar o valor total
    final cart = Provider.of<CartProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Confirmar Venda Fiado'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Faz a coluna se ajustar ao conteúdo
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Cliente: ${widget.customer.name}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Valor Total: R\$ ${cart.totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(height: 24),
          const Text('Definir data de vencimento:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Mostra a data selecionada ou um texto padrão
              Text(
                _selectedDate == null
                    ? 'Nenhuma data'
                    : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              ),
              TextButton(
                onPressed: _presentDatePicker,
                child: const Text('Escolher Data'),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop(); // Fecha apenas este dialog
          },
        ),
        ElevatedButton(
          // O botão só fica ativo se uma data for escolhida
          onPressed: _selectedDate == null
              ? null
              : () {
            // TODO: Lógica final para salvar a venda no banco de dados
            Provider.of<SalesProvider>(context, listen: false).addOrder(
              cartProducts: cart.items.values.toList(),
              total: cart.totalAmount,
              customer: widget.customer,
              dueDate: _selectedDate!,
              // TODO: Passar as observações do carrinho para cá
            );

            // Limpa o carrinho após a venda
            cart.clear();

            // Fecha todos os painéis e volta para a tela inicial de vendas
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('Confirmar Venda'),
        ),
      ],
    );
  }
}