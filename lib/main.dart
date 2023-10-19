import 'package:flutter/material.dart';
import 'package:shop/views/products_overview_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Loja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
        ).copyWith(
          secondary: Colors.deepOrange,
        ),
        fontFamily: 'Lato',
      ),
      home: ProductOverviewScreen(),
    );
  }
}
