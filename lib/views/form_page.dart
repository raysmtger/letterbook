import 'package:flutter/material.dart';
import 'package:letterbook/models/diario_model.dart';
import 'package:letterbook/services/diario_services.dart';
import 'package:letterbook/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormsDiario extends StatefulWidget {
  final Diario? diario;

  FormsDiario({this.diario});

  @override
  _FormsDiarioState createState() => _FormsDiarioState();
}

class _FormsDiarioState extends State<FormsDiario> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _diarioService = DiarioService();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.diario != null) {
      _titleController.text = widget.diario!.title;
      _descriptionController.text = widget.diario!.description;
      _selectedDate = widget.diario!.date;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diario != null ? 'Editar Diário' : 'Novo Diário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 69, 42, 16)), // Cor marrom para o texto "Título"
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Querido Diário',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 69, 42, 16)), // Cor marrom para o texto "Descrição"
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    "Data: ${_selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(color: Color.fromARGB(255, 69, 42, 16)), 
                  ),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 69, 42, 16), 
                    ),
                    child: Text(
                      'Selecionar Data',
                      style: TextStyle(color: Colors.white), 
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final diario = Diario(
                      id: widget.diario?.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      date: _selectedDate,
                      userId: '',
                    );

                    if (widget.diario != null) {
                      await _diarioService.atualizarDiario(
                        diario.id!,
                        diario.title,
                        diario.description,
                        diario.date,
                      );
                    } else {
                      await _diarioService.adicionarDiario(
                        diario.title,
                        diario.description,
                        diario.date,
                      );
                    }
                  }

                  Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(
    builder: (context) => HomePage(user: FirebaseAuth.instance.currentUser!),
  ),
  (route) => false,
);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 69, 42, 16),
                ),
                child: Text(
                  widget.diario != null ? 'Atualizar' : 'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
