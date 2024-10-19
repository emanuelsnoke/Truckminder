import 'package:flutter/material.dart';
import 'package:truckminder/page/chamado.dart';
import 'package:truckminder/page/chamados.dart';
import 'package:truckminder/page/dadosCadastrais.dart';
import 'package:truckminder/page/login.dart';

class Dashboard extends StatefulWidget {
  final int userId; // Adiciona userId
  final String userName; // Adiciona userName

  const Dashboard({super.key, required this.userId, required this.userName}); // Modifique o construtor

  @override
  State<Dashboard> createState() => HomeState();
}

class HomeState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TruckMinder'),
        backgroundColor: const Color.fromARGB(255, 33, 50, 75),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.userName, style: const TextStyle(color: Colors.white)), // Exibe o nome do usuário
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://www.w3schools.com/howto/img_avatar.png',
              ),
              radius: 20,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            // Primeira linha: "Agendamento" e "Dados Cadastrais"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chamado(userId: widget.userId), // Use widget.userId aqui
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 60),  
                        backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Agendamento"),
                    ),
                  ),
                  const SizedBox(width: 20), // Espaço entre os botões
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DadosCadastrais(userId: widget.userId), // Use widget.userId aqui
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 60),  
                        backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Dados Cadastrais"),
                    ),
                  ),
                ],
              ),
            ),
            // Segunda linha: "Chamado" e "Suporte"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chamados(userId: widget.userId), // Use widget.userId aqui
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 60),  
                        backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Chamado"),
                    ),
                  ),
                  const SizedBox(width: 20), // Espaço entre os botões
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Ação para o botão "Suporte"
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 60),  
                        backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Suporte"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 250), // Espaço para separar o botão logout
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false, // Remove todas as rotas anteriores
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 60),
                  backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
