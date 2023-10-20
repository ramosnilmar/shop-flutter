import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((p) => p.isFavorite).toList();

  int get itemsCount => _items.length;

  void addProduct(
    Product product,
  ) {
    _items.add(
      Product(
        id: Random().nextDouble().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  void updateProduct(
    Product product,
  ) {
    if (product.id == null || product.id!.isEmpty) {
      return;
    }

    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    final index = items.indexWhere((p) => p.id == id);
    if (index >= 0) {
      _items.removeWhere((p) => p.id == id);
      notifyListeners();
    }
  }
}
