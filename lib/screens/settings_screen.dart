// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Carrega a preferência salva no dispositivo de forma segura
  Future<void> _loadFiadoPreference() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _fiadoEnabled = prefs.getBool('fiado_enabled') ?? false;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar configurações: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Salva a preferência quando o usuário muda o interruptor
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

  // Mostra o diálogo para alterar a senha
  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha Atual'),
                  validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Nova Senha'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Campo obrigatório';
                    if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres.';
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirmar Nova Senha'),
                  validator: (value) {
                    if (value != newPasswordController.text) return 'As senhas não coincidem.';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            child: const Text('Salvar'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final user = FirebaseAuth.instance.currentUser;
                final cred = EmailAuthProvider.credential(
                  email: user!.email!,
                  password: currentPasswordController.text,
                );

                try {
                  await user.reauthenticateWithCredential(cred);
                  await user.updatePassword(newPasswordController.text);

                  if (context.mounted) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Senha alterada com sucesso!'), backgroundColor: Colors.green),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  String errorMessage = 'Ocorreu um erro.';
                  if (e.code == 'wrong-password') {
                    errorMessage = 'A senha atual está incorreta.';
                  } else if (e.code == 'weak-password') {
                    errorMessage = 'A nova senha é muito fraca.';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // Mostra o diálogo para alterar o e-mail
  void _showChangeEmailDialog(BuildContext context) {
    final newEmailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alterar E-mail'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: newEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Novo E-mail'),
                  validator: (value) {
                    if (value == null || !value.contains('@')) return 'Insira um e-mail válido.';
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha Atual'),
                  validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            child: const Text('Salvar'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final user = FirebaseAuth.instance.currentUser;
                final cred = EmailAuthProvider.credential(
                  email: user!.email!,
                  password: passwordController.text,
                );

                try {
                  await user.reauthenticateWithCredential(cred);
                  await user.verifyBeforeUpdateEmail(newEmailController.text);

                  if (context.mounted) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link de verificação enviado para o novo e-mail!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  String errorMessage = 'Ocorreu um erro.';
                  if (e.code == 'wrong-password') {
                    errorMessage = 'A senha está incorreta.';
                  } else if (e.code == 'email-already-in-use') {
                    errorMessage = 'Este e-mail já está sendo usado por outra conta.';
                  } else if (e.code == 'invalid-email') {
                    errorMessage = 'O novo e-mail fornecido é inválido.';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Alterar Senha'),
            subtitle: const Text('Mude sua senha de acesso.'),
            onTap: () {
              _showChangePasswordDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: const Text('Alterar E-mail'),
            subtitle: const Text('Mude seu e-mail de login.'),
            onTap: () {
              _showChangeEmailDialog(context);
            },
          ),
          const Divider(height: 20, indent: 16, endIndent: 16),
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