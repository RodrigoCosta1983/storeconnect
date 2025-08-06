// Em lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _fiadoEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiadoPreference();
  }

  // Função de carregamento mais robusta com tratamento de erro
  Future<void> _loadFiadoPreference() async {
    // Garante que o estado de loading inicial seja verdadeiro
    if (mounted) setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      // Usamos 'mounted' para garantir que o widget ainda está na tela antes de chamar o setState
      if (mounted) {
        setState(() {
          _fiadoEnabled = prefs.getBool('fiado_enabled') ?? false;
        });
      }
    } catch (error) {
      // Se ocorrer um erro, exibe uma mensagem para o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar configurações: $error')),
        );
      }
    } finally {
      // O bloco 'finally' SEMPRE será executado, com ou sem erro
      // Isso garante que a tela nunca fique "travada" no loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Função de salvar (também pode ser mais robusta)
  Future<void> _saveFiadoPreference(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _fiadoEnabled = value;
      });
      await prefs.setBool('fiado_enabled', value);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuração salva!'), duration: Duration(seconds: 1)),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar configuração: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          SwitchListTile(
            title: const Text('Habilitar Vendas "Fiado"'),
            subtitle: const Text('Permite registrar vendas a prazo para clientes.'),
            value: _fiadoEnabled,
            onChanged: _saveFiadoPreference,
            secondary: const Icon(Icons.receipt_long_outlined),
          ),
        ],
      ),
    );
  }
}