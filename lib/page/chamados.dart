import 'package:flutter/material.dart';
import 'package:truckminder/Models/user.dart';

class Chamados extends StatefulWidget {
  const Chamados({super.key, required int userId});

  @override
  State<Chamados> createState() => HomeState();
}

class HomeState extends State<Chamados> {
  late Future<List<Map<String, dynamic>>> _callsFuture; // Chamados de todos os usuários

  @override
  void initState() {
    super.initState();
    _callsFuture = _getAllCalls(); // Busca todos os chamados
  }

  // Função para buscar todos os chamados no banco de dados
  Future<List<Map<String, dynamic>>> _getAllCalls() async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.getAllCalls(); // Altere esta função no seu DatabaseHelper
  }

  // Função para excluir um chamado do banco de dados
  Future<void> _deleteCall(int callId) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteCall(callId);
    setState(() {
      _callsFuture = _getAllCalls(); // Atualiza a lista de todos os chamados
    });
  }

  // Função para mostrar os detalhes do chamado
  void _showCallDetails(Map<String, dynamic> call) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalhes'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Placa: ${call['license_plate']}'),
                Text('Km: ${call['km']}'),
                Text('Data: ${call['date']}'),
                Text('Hora: ${call['time']}'),
                const SizedBox(height: 8.0),
                Text('Observações: ${call['details']}'), // Exibe os detalhes do chamado
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _callsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar os chamados.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum chamado encontrado.'));
                  }

                  final calls = snapshot.data!;

                  return ListView.builder(
                    itemCount: calls.length,
                    itemBuilder: (context, index) {
                      final call = calls[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 38, 50, 68),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Placa: ${call['license_plate']}',
                                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                                ),
                                Text(
                                  'Data: ${call['date']}',
                                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Km: ${call['km']}',
                                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                                ),
                                Text(
                                  'Hora: ${call['time']}',
                                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _deleteCall(call['id']); // Exclui o chamado
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 40),
                                    backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Finalizar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _showCallDetails(call); // Exibe os detalhes do chamado
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 40),
                                    backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Ver mais'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 60),
                backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                foregroundColor: Colors.white,
              ),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
