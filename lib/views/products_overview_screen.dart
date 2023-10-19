import 'package:flutter/material.dart';
import 'package:shop/widgets/product_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
      ),
      body: const ProductGrid(),
    );
  }
}
