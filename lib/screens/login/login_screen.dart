// lib/screens/login/login_screen.dart

import 'package:flutter/material.dart';
import 'package:tienda_model/screens/sales/new_sale_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // Detecta se o tema atual é escuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Usamos um Stack para colocar a imagem de fundo atrás do conteúdo
      body: Stack(
        children: [
          // --- NOSSA MUDANÇA ESTÁ AQUI ---
          // Container para o background
          //if (isDarkMode) // A imagem só aparece se for modo escuro
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_dark.jpg'), // Caminho da sua imagem
                  fit: BoxFit.cover, // Faz a imagem cobrir toda a tela
                  opacity: 0.5, // Deixa a imagem um pouco transparente para não atrapalhar a leitura
                ),
              ),
            ),
          // --- FIM DA MUDANÇA ---

          // Conteúdo da tela de login
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Logo
                    Icon(
                      Icons.ac_unit,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 24),

                    // 2. Título de Boas-Vindas
                    const Text(
                      'Bem-vindo a EMPRESA!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Acesse sua conta para continuar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // 3. Campo de E-mail
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).canvasColor.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Campo de Senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).canvasColor.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 5. Link "Esqueci minha senha?"
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Esqueci minha senha?'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 6. Botão de Entrar
                    ElevatedButton(
                      onPressed: () {
                        // Lógica de autenticação será adicionada aqui no futuro.
                        // Por enquanto, apenas navegamos para a próxima tela.

                        // Usamos o pushReplacement para que o usuário não possa
                        // apertar "voltar" e retornar para a tela de login.
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => NewSaleScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'ENTRAR',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}