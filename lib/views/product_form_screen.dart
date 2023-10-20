import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context)?.settings.arguments as Product?;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    if (_isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool _isValidImageUrl(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');

    bool isValidExtension = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidProtocol && isValidExtension;
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState?.save();

    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);

    try {
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updateProduct(product);
      }
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Ocorreu um erro!'),
                content: const Text('Ocorreu um erro pra salvar o produto!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário Produto'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _saveForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _formData['title'],
                          decoration:
                              const InputDecoration(labelText: 'Título'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) => _formData['title'] = value,
                          validator: (value) {
                            bool isEmpty =
                                value == null || value.trim().isEmpty;
                            bool isInvalid = isEmpty || value.trim().length < 3;
                            if (isInvalid) {
                              return 'Informe um título válido';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _formData['price'].toString(),
                          decoration: const InputDecoration(labelText: 'Preço'),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          onSaved: (value) =>
                              _formData['price'] = double.parse(value!),
                          validator: (value) {
                            bool isEmpty =
                                value == null || value.trim().isEmpty;
                            var newPrice = double.tryParse(value ?? '');

                            bool isInvalid =
                                isEmpty || newPrice == null || newPrice <= 0;

                            if (isInvalid) {
                              return 'Informe um preço válido';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _formData['description'],
                          decoration:
                              const InputDecoration(labelText: 'Descrição'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) => _formData['description'] = value,
                          validator: (value) {
                            bool isEmpty =
                                value == null || value.trim().isEmpty;
                            bool isInvalid =
                                isEmpty || value.trim().length < 10;

                            if (isInvalid) {
                              return 'Informe uma descrição válida com no mínimo 10 caracteres';
                            }

                            return null;
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'URL da Imagem'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                focusNode: _imageUrlFocusNode,
                                controller: _imageUrlController,
                                onFieldSubmitted: (_) => _saveForm(),
                                onSaved: (value) =>
                                    _formData['imageUrl'] = value,
                                validator: (value) {
                                  bool isEmpty =
                                      value == null || value.trim().isEmpty;
                                  bool isInvalid =
                                      isEmpty || !_isValidImageUrl(value);

                                  if (isInvalid) {
                                    return 'Informe uma URL válida';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 8,
                                left: 10,
                              ),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: _imageUrlController.text.isEmpty
                                  ? const Text('Informe a URL')
                                  : SizedBox.expand(
                                      child: FittedBox(
                                        child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
