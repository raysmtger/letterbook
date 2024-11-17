import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letterbook/models/diario_model.dart';
import 'package:letterbook/services/authentication_service.dart';
import 'package:letterbook/views/form_page.dart';
import 'package:letterbook/services/diario_services.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DiarioService _diarioService = DiarioService();

  void _showBottomSheet(Diario diario) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Color.fromARGB(255, 242, 214, 196),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    diario.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color.fromARGB(255, 69, 42, 16)),
                        onPressed: () {
                          Navigator.pop(context); // Fechar a modal
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormsDiario(diario: diario),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _diarioService.deleteDiario(diario.id!);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Data: ${diario.date.toLocal()}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(diario.description),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LetterBook: Diário Virtual',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 69, 42, 16),
      ),
      backgroundColor: Color.fromARGB(199, 242, 214, 196),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(199, 242, 214, 196),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 69, 42, 16),
              ),
              accountName: Text(
                widget.user.displayName ?? "Não informado",
              ),
              accountEmail: Text(
                widget.user.email ?? "Não informado",
              ),
            ),
            ListTile(
              title: Text("Sair"),
              leading: Icon(Icons.logout),
              onTap: () async {
                await AuthenticationService().logoutUser();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(199, 78, 48, 19),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromARGB(255, 69, 42, 16),
                  width: 1.5,
                ),
              ),
              child: Text(
                "Querido Diário...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('diarios').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Erro ao carregar dados"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("Nenhum diário encontrado"));
                  }

                  var notes = snapshot.data!.docs;

                  return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      String title = note['title'] ?? 'Sem Título';
                      String description = note['description'] ?? 'Sem descrição';
                      DateTime date = (note['date'] as Timestamp).toDate();

                       Diario diario = Diario(
                        id: note.id,
                        title: title,
                        description: description,
                        date: date, userId: '',
                      );

                      return GestureDetector(
                        onTap: () {
                          _showBottomSheet(diario);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  description.length > 50
                                      ? description.substring(0, 50) + '...'
                                      : description,
                                ),
                                SizedBox(height: 8),
                                Text('Data: ${date.toLocal()}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormsDiario(),
                    ),
                  );
                },
                backgroundColor: Color.fromARGB(255, 69, 42, 16),
                foregroundColor: Colors.white,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}