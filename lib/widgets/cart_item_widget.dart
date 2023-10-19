import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => Provider.of<Cart>(context, listen: false)
          .removeItem(cartItem.productId),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    '${cartItem.price}',
                    style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.titleMedium?.color,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              cartItem.title,
            ),
            subtitle: Text(
              'Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
            ),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
