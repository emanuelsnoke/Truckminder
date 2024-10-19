import 'package:flutter/material.dart';
import 'package:truckminder/Models/user.dart';
import 'package:truckminder/page/Dashboard.dart';
import 'package:truckminder/page/cadastro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => HomeState();
}

class HomeState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String _errorMessage = '';

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha todos os campos';
      });
      return;
    }

    List<Map<String, dynamic>> result =
        await _dbHelper.getUsersByEmailAndPassword(email, password);

    if (result.isNotEmpty) {
      int userId = result[0]['id'];
      String userName = result[0]['name'];
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(userId: userId, userName: userName)),
      );
    } else {
      setState(() {
        _errorMessage = 'Email ou senha incorretos';
      });
    }
  }

  // Função para "Entrar como Funcionário"
  void _loginAsEmployee() {
    // Aqui você pode definir a lógica para "Entrar como Funcionário"
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard(userId: 1, userName: 'Funcionário')), // Exemplo fictício
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 250,
                height: 250,
                child: Image.asset('assets/logo.png'),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  width: 320,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                          color: Colors.black, fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 33, 50, 75), // Cor da borda
                        ),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  width: 320,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: const TextStyle(
                          color: Colors.black, fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 33, 50, 75), // Cor da borda
                        ),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox( // Usando SizedBox para definir um tamanho fixo
                  width: 320, // Definindo a largura do botão
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                      foregroundColor: Colors.white, // Definindo a cor do texto como branco
                      textStyle: const TextStyle(fontSize: 20), // Somente o tamanho do texto
                    ),
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
                ),
              ),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  width: 320,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Cadastro()),
                      );
                    },
                    child: const Text('Registrar-se'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  width: 360,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                          foregroundColor: const Color.fromARGB(255, 33, 50, 75),
                          textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: _loginAsEmployee,
                    child: const Text('Entrar como Funcionário'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
