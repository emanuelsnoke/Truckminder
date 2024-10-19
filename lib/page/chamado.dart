import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truckminder/Models/user.dart'; // Ajuste o caminho conforme necessário

class Chamado extends StatefulWidget {
  final int userId;

  const Chamado({Key? key, required this.userId}) : super(key: key);

  @override
  State<Chamado> createState() => _ChamadoState();
}

class _ChamadoState extends State<Chamado> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _kmController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _observacoesController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _formatData() {
    String data = _dataController.text.replaceAll('/', '');
    if (data.length >= 8) {
      data = '${data.substring(0, 2)}/${data.substring(2, 4)}/${data.substring(4, 8)}';
      _dataController.text = data;
    }
  }

  void _formatHora() {
    String hora = _horaController.text.replaceAll(':', '');
    if (hora.length >= 4) {
      int hour = int.parse(hora.substring(0, 2));
      String suffix = hour >= 12 ? ' PM' : ' AM';
      hour = hour > 12 ? hour - 12 : hour == 0 ? 12 : hour;
      String formattedHora = '${hour.toString().padLeft(2, '0')}:${hora.substring(2, 4)} $suffix';
      _horaController.text = formattedHora;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Chamado'),
        backgroundColor: const Color.fromARGB(255, 33, 50, 75),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                TextFormField(
                  controller: _placaController,
                  decoration: const InputDecoration(
                    labelText: 'Placa',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a placa';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _kmController,
                  decoration: const InputDecoration(
                    labelText: 'Km',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o Km';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dataController,
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  keyboardType: TextInputType.datetime,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => _formatData(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a Data';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _horaController,
                  decoration: const InputDecoration(
                    labelText: 'Hora',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  keyboardType: TextInputType.datetime,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => _formatHora(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a Hora';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _observacoesController,
                  decoration: const InputDecoration(
                    labelText: 'Observações',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                        ),
                        child: const Text(
                          'Voltar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _registrarChamado();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chamado registrado com sucesso')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 33, 50, 75),
                        ),
                        child: const Text(
                          'Encaminhar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função para registrar o chamado no banco de dados
  Future<void> _registrarChamado() async {
    Map<String, dynamic> chamado = {
      'date': _dataController.text, // A data já estará no formato dd/MM/yyyy
      'time': _horaController.text, // A hora já estará no formato hh:mm AM/PM
      'km': _kmController.text,
      'license_plate': _placaController.text,
      'details': _observacoesController.text,
      'user_id': widget.userId,
    };

    await _dbHelper.insertCall(chamado);
  }
}
