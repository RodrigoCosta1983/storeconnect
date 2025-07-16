import 'package:flutter/material.dart';
import 'package:tienda_model/screens/sales/new_sale_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Certifique-se de que os imports estão corretos

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoginMode = true;
  var _isLoading = false;

  var _enteredEmail = '';
  var _enteredPassword = '';

  final _firebaseAuth = FirebaseAuth.instance;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await _firebaseAuth.signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
      } else {
        await _firebaseAuth.createUserWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => NewSaleScreen()),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Ocorreu um erro.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // A cor de fundo dos campos será diferente para cada modo
    final fillColor = isDarkMode
        ? Theme.of(context).canvasColor.withOpacity(0.5)
        : Colors.white;

    return Scaffold(
      body: Stack(
        children: [
          // A imagem de fundo só é construída se o modo for escuro
          //if (isDarkMode)
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_dark.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
            ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.ac_unit, size: 80, color: Theme.of(context).primaryColor),
                      const SizedBox(height: 24),
                      Text(
                        _isLoginMode ? 'Bem-vindo de volta!' : 'Crie sua conta',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 48),

                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: fillColor,
                        ),
                        validator: (value) {
                          if (value == null || !value.contains('@')) return 'Por favor, insira um e-mail válido.';
                          return null;
                        },
                        onSaved: (value) => _enteredEmail = value!,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: fillColor,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 6) return 'A senha deve ter no mínimo 6 caracteres.';
                          return null;
                        },
                        onSaved: (value) => _enteredPassword = value!,
                      ),
                      const SizedBox(height: 24),

                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                          child: Text(_isLoginMode ? 'ENTRAR' : 'REGISTRAR', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),

                      if (!_isLoading)
                        TextButton(
                          onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                          child: Text(_isLoginMode ? 'Não tem uma conta? Registre-se' : 'Já tem uma conta? Faça login'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}