import 'package:flutter/material.dart';
import 'package:truckminder/Models/user.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => HomeState();
}

class HomeState extends State<Cadastro> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String _errorMessage = '';

  Future<void> _register() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Verifica se os campos estão preenchidos
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha todos os campos';
      });
      return;
    }

    // Verifica se as senhas coincidem
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'As senhas não coincidem';
      });
      return;
    }

    // Cria um novo usuário
    Map<String, dynamic> user = {
      'name': name,
      'email': email,
      'password': password,
    };

    // Insere o usuário no banco de dados
    await _dbHelper.insertUser(user);

    // Navega para a tela de login ou outra tela
    Navigator.pop(context); // Volta para a tela anterior (Login)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Usando o ícone de seta para voltar
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nome completo:',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white), // Cor do texto preenchido
            ),
            const SizedBox(height: 10),
            const Text(
              'E-mail:',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Senha:',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              'Confirmar senha:',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 33, 50, 75),
              ),
              child: const Text('Enviar cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
