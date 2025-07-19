import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:tienda_model/providers/cart_provider.dart';
import 'package:tienda_model/providers/sales_provider.dart';
import 'package:tienda_model/providers/cash_flow_provider.dart';
import 'package:tienda_model/screens/login/login_screen.dart';
import 'package:tienda_model/themes/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// 1. MyApp agora é um StatefulWidget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // 2. Ele tem o método obrigatório createState
  @override
  State<MyApp> createState() => _MyAppState();
}

// 3. A lógica e o método build foram movidos para a classe de estado _MyAppState
class _MyAppState extends State<MyApp> {
  bool _imagesPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Faz o pré-carregamento das imagens
    if (!_imagesPrecached) {
      _precacheImages(context);
      _imagesPrecached = true;
    }
  }

  void _precacheImages(BuildContext context) {
    precacheImage(const AssetImage('assets/images/background_dark.jpg'), context);
    precacheImage(const AssetImage('assets/images/background_light.jpg'), context);
    print('Imagens de fundo pré-carregadas na memória.');
  }

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