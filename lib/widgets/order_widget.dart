import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key, required this.order});

  final Order order;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeight = widget.order.products.length * 25.0 + 10;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight + 112 : 112,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('R\$ ${widget.order.amount.toStringAsFixed(2)}'),
                subtitle: Text(
                    DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
                trailing: IconButton(
                  icon: const Icon(Icons.expand_more),
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _expanded ? itemsHeight : 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: ListView(
                  shrinkWrap: true,
                  children: widget.order.products.map((product) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${product.quantity}x R\$ ${product.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
