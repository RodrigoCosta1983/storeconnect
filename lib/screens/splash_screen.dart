// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:master_gelo/firebase_options.dart';
import 'package:master_gelo/screens/auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Esta verificação resolve o erro de app duplicado
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        // Se você estiver usando o FlutterFire CLI, a linha abaixo é necessária
        // options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    // Aguarda um pequeno tempo para o logo ser visível (opcional, mas bom para UX)
    await Future.delayed(const Duration(seconds: 2));

    // Navega para o AuthGate, que decidirá entre Login e Tela Principal
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Esta é a tela que o usuário vê enquanto o app inicializa
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Master Gelo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
// [CORREÇÃO] Chave extra '}' foi removida do final do arquivo