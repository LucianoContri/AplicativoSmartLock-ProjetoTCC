import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlock/exceptions/AuthException.dart';
import 'package:smartlock/models/Auth.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyConfirm = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _AuthData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _SwitchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showErrorDialog(String mensagem) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(''),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isEmailValid = _formKeyEmail.currentState?.validate() ?? false;
    final isPasswordValid = _formKeyPassword.currentState?.validate() ?? false;
    final isConfirmValid = _formKeyConfirm.currentState?.validate() ?? false;

    final isValidLogin = isEmailValid && isPasswordValid;
    final isValidSignup = isConfirmValid && isEmailValid && isPasswordValid;

    setState(() => _isLoading = true);

    _formKeyEmail.currentState?.save();
    _formKeyPassword.currentState?.save();
    _formKeyConfirm.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin() && isValidLogin) {
        await auth.login(
          _AuthData['email']!,
          _AuthData['password']!,
        );
      } else if (_isSignup() && isValidSignup) {
        await auth.signup(
          _AuthData['email']!,
          _AuthData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro, é a vida!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Form(
            key: _formKeyEmail,
            child: Container(
              height: deviceSize.width * 0.12,
              width: deviceSize.width * 0.90,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _AuthData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Form(
            key: _formKeyPassword,
            child: Container(
              height: deviceSize.width * 0.12,
              width: deviceSize.width * 0.90,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                  decoration: InputDecoration(labelText: 'Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (senha) => _AuthData['password'] = senha ?? '',
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.isEmpty || password.length < 5) {
                      return 'informe uma senha válida';
                    }
                    return null;
                  }),
            ),
          ),
        ),
        if (_isSignup())
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Form(
              key: _formKeyConfirm,
              child: Container(
                height: deviceSize.width * 0.12,
                width: deviceSize.width * 0.90,
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return "Senhas informadas não correspondem";
                          }
                          return null;
                        },
                ),
              ),
            ),
          ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: CircularProgressIndicator(),
          )
        else
          Container(
            height: deviceSize.width * 0.20,
            width: deviceSize.width * 0.50,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(
                _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
              ),
              style: ElevatedButton.styleFrom(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        if (!_isLoading)
          TextButton(
            onPressed: _SwitchAuthMode,
            child: Text(_isLogin() ? 'Registrar' : 'Já Possuo Conta'),
          ),
      ],
    );
  }
}
