import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final GlobalKey<FormState> _form = GlobalKey();
  final _passwordController = TextEditingController();

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fechar'),
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.login) {
        await auth.login(
          email: _authData['email']!,
          password: _authData['password']!,
        );
      } else {
        await auth.signup(
          email: _authData['email']!,
          password: _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      showErrorDialog(error.toString());
    } catch (error) {
      showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.login ? 310 : 390,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => _authData['email'] = newValue!,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Informe um e-mail válido!';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                controller: _passwordController,
                obscureText: true,
                onSaved: (newValue) => _authData['password'] = newValue!,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Informe uma senha válida!';
                  }
                  return null;
                },
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.signup ? 60 : 0,
                  maxHeight: _authMode == AuthMode.signup ? 120 : 0,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Confirmar Senha'),
                      obscureText: true,
                      validator: _authMode == AuthMode.signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Senhas são diferentes!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                    textStyle: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.labelLarge?.color,
                    ),
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                  ),
                ),
              TextButton(
                onPressed: () {
                  _switchAuthMode();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 4,
                  ),
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(
                  _authMode == AuthMode.login
                      ? 'REGISTRAR-SE'
                      : 'ENTRAR COM UMA CONTA',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
