import 'package:flutter/material.dart';
import 'package:truckminder/Models/user.dart'; // Ajuste o caminho conforme necessário

class DadosCadastrais extends StatefulWidget {
  final int userId; // ID do usuário logado

  const DadosCadastrais({Key? key, required this.userId}) : super(key: key);

  @override
  State<DadosCadastrais> createState() => _DadosCadastraisState();
}

class _DadosCadastraisState extends State<DadosCadastrais> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _obscurePassword = true; // Para controlar a visibilidade da senha

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    List<Map<String, dynamic>> user = await _dbHelper.getUsers();
    if (user.isNotEmpty) {
      _nameController.text = user[0]['name'];
      _emailController.text = user[0]['email'];
      _passwordController.text = user[0]['password'];
    }
  }

  Future<void> _updateUser() async {
    Map<String, dynamic> updatedUser = {
      'id': widget.userId,
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    
    await _dbHelper.updateUser(updatedUser);
    
    // Voltar ou mostrar uma mensagem de sucesso
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Cadastrais', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 33, 50, 75),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nome:', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text('E-mail:', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text('Senha:', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                foregroundColor: Colors.white,
              ),
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
