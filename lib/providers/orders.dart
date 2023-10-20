import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  final String _baseUrl = '${Constants.baseUrlApi}/orders';

  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> loadOrders() async {
    final response = await http.get(Uri.parse('$_baseUrl.json'));
    Map<String, dynamic>? data = jsonDecode(response.body);

    List<Order> loadedItems = [];

    if (data != null) {
      data.forEach((key, value) {
        loadedItems.add(Order(
          id: key,
          amount: value['amount'],
          date: DateTime.parse(value['date']),
          products: (value['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ));
      });
      notifyListeners();
    }
    _items = loadedItems.reversed.toList();

    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode({
        'amount': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map(
              (cartItem) => {
                'id': cartItem.id,
                'productId': cartItem.productId,
                'title': cartItem.title,
                'quantity': cartItem.quantity,
                'price': cartItem.price,
              },
            )
            .toList(),
      }),
    );

    _items.insert(
      0,
      Order(
        id: jsonDecode(response.body)['name'],
        amount: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }
}
