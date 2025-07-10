import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importe a nova tela
import 'package:tienda_model/providers/cart_provider.dart';
import 'package:tienda_model/screens/login/login_screen.dart';
import 'package:tienda_model/screens/sales/new_sale_screen.dart';
import 'package:tienda_model/themes/app_theme.dart';

import 'providers/cash_flow_provider.dart';
import 'providers/sales_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos o MultiProvider para gerenciar múltiplos providers
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