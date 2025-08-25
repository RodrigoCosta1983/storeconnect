// lib/screens/auth/auth_gate.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:master_gelo/screens/login/login_screen.dart';
import 'package:master_gelo/screens/sales/new_sale_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // 1. Escuta as mudanças no estado de autenticação do Firebase
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Se ainda está esperando para verificar, mostra um loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Se o snapshot tem dados (um usuário), o usuário está logado
        if (snapshot.hasData) {
          return NewSaleScreen(); // Vai para a tela principal
        }

        // 3. Se não tem dados, o usuário está deslogado
        return const LoginScreen(); // Vai para a tela de login
      },
    );
  }
}