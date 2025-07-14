import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/sale_order_model.dart';
import '../providers/cash_flow_provider.dart';
import '../providers/sales_provider.dart';

// 1. Convertemos para um StatefulWidget
class OrderItemWidget extends StatefulWidget {
  final SaleOrder order;

  const OrderItemWidget({super.key, required this.order});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  // 2. Criamos uma variável de estado para controlar a expansão
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Usamos 'widget.order' para acessar o pedido dentro do State
    final bool isOverdue = !widget.order.isPaid && widget.order.dueDate.isBefore(DateTime.now());

    final salesProvider = Provider.of<SalesProvider>(context, listen: false);
    final cashFlowProvider = Provider.of<CashFlowProvider>(context, listen: false);

    return Card(
      shape: isOverdue
          ? RoundedRectangleBorder(
        side: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      )
          : null,
      margin: const EdgeInsets.all(10),
      child: ExpansionTile(
        // 3. Usamos nossas variáveis de estado para controlar o ExpansionTile
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (isExpanding) {
          setState(() {
            _isExpanded = isExpanding;
          });
        },

        title: Text('R\$ ${widget.order.amount.toStringAsFixed(2)}'),
        subtitle: Text('Cliente: ${widget.order.customer.name}'),
        trailing: Text(DateFormat('dd/MM/yy').format(widget.order.date)),
        leading: widget.order.isPaid
            ? const Icon(Icons.check_circle, color: Colors.green)
            : isOverdue
            ? const Icon(Icons.warning, color: Colors.red)
            : const Icon(Icons.receipt_long),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Vencimento: ${DateFormat('dd/MM/yyyy').format(widget.order.dueDate)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isOverdue ? Colors.red : Colors.grey[700],
                      ),
                    ),
                    if (isOverdue)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          '(VENCIDO)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      )
                  ],
                ),
                const Divider(),
                ...widget.order.products.map(
                      (prod) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          prod.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${prod.quantity}x R\$${prod.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ).toList(),

                if (!widget.order.isPaid)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Marcar como Pago'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
<<<<<<< HEAD
                          // Agora passamos também o valor do pedido
                          salesProvider.markOrderAsPaid(widget.order.id, widget.order.amount, cashFlowProvider);
=======
                          salesProvider.markOrderAsPaid(widget.order.id, cashFlowProvider);
>>>>>>> 5adddfbc9206da942d50765e62fcc7ef61a1b765
                        },
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}