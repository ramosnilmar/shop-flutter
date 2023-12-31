import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/widgets/app_bar_widget.dart';
import 'package:shop/widgets/cart_item_widget.dart';
import 'package:shop/widgets/sales_button_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Carrinho',
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: cart.itemsCount < 1
                ? const Center(
                    child: Text('Nenhum Produto adicionado'),
                  )
                : ListView.builder(
                    itemCount: cart.itemsCount,
                    itemBuilder: (ctx, i) => CartItemWidget(
                      cartItem: cartItems[i],
                    ),
                  ),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Spacer(),
                  SalesButton(cart: cart)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
