import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/constants.dart';

class Products with ChangeNotifier {
  final String _baseUrl = '${Constants.baseUrlApi}/products';

  final String? _userId;
  final String? _token;

  List<Product> _items = [];

  Products([this._token, this._userId, this._items = const []]);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((p) => p.isFavorite).toList();

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl.json?auth=$_token'));
    Map<String, dynamic>? data = jsonDecode(response.body);

    final favResponse = await http.get(Uri.parse(
        '${Constants.baseUrlApi}/userFavorite/$_userId.json?auth=$_token'));

    final favMap = jsonDecode(favResponse.body);

    List<Product> loadedItems = [];

    if (data != null) {
      data.forEach((productId, value) {
        final isFavorite = favMap == null ? false : favMap[productId] ?? false;
        loadedItems.add(Product(
          id: productId,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: isFavorite,
        ));
      });
      notifyListeners();
    }
    _items = loadedItems.reversed.toList();

    return Future.value();
  }

  Future<void> addProduct(
    Product product,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl.json?auth=$_token'),
      body: jsonEncode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );

    _items.add(
      Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(
    Product product,
  ) async {
    if (product.id == null || product.id!.isEmpty) {
      return;
    }

    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    final index = items.indexWhere((p) => p.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http
          .delete(Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'));
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto.');
      }
    }
  }
}
