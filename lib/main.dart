import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Importe os pacotes do Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:tienda_model/providers/cart_provider.dart';
import 'package:tienda_model/providers/sales_provider.dart';
import 'package:tienda_model/providers/cash_flow_provider.dart';
import 'package:tienda_model/screens/login/login_screen.dart';
import 'package:tienda_model/themes/app_theme.dart';


// 2. Transforme a main em uma função assíncrona
void main() async {
  // 3. Garanta que o Flutter está pronto
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Inicialize o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => SalesProvider()),
        ChangeNotifierProvider(create: (ctx) => CashFlowProvider()),
      ],
      child: MaterialApp(
        title: 'Gelo Gestor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}