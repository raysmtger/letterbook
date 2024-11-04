import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letterbook/services/authentication_service.dart';


class HomePage extends StatefulWidget{
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Incial',
        style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Color.fromARGB(255, 69, 42, 16),
      ),
      backgroundColor: Color.fromARGB(199, 242, 214, 196),
      drawer: Drawer(
        child: Column(
          children: [  
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.displayName != null
              ? widget.user.displayName!
              : "Não informado"
              ), 
              accountEmail: Text(widget.user.email != null
              ? widget.user.email!
              : "Não informado"),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 69, 42, 16),  // muduei o campo de usuário para marrom
              ),
            ),
            
            ListTile(
              title: Text("Sair"),
              leading: Icon(Icons.logout,
              ),
              
              onTap: (){
                AuthenticationService().logoutUser();
              },
            )
          ],
        ),
      ),
     //começou o conteúdo, coloquei a pergunta do começo
     body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
          "O que você está pensando hoje?",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
          ),
        ),
      ),
    ],
  ),
),
    );
  }
} 
