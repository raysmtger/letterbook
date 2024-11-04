import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letterbook/services/authentication_service.dart';
import 'package:letterbook/widgets/text_field_widget.dart';
import 'package:letterbook/widgets/snack_bar_widget.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login",
          style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 69, 42, 16)
        ),
        backgroundColor: Color.fromARGB(199, 242, 214, 196),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset("assets/LetterBook (1)-Photoroom.png", width: 200, height: 200),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          labelStyle: TextStyle(color: Color.fromARGB(255, 69, 42, 16)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 69, 42, 16)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 69, 42, 16)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 69, 42, 16)),
                          ),
                        ),
                        validator: (value) => requiredValidator(value, "o email"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(color: Color.fromARGB(255, 69, 42, 16)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 69, 42, 16)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 69, 42, 16)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 69, 42, 16)),
                          ),
                        ),
                        validator: (value) => requiredValidator(value, "a senha"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            _authService.loginUser(
                              email: email, password: password).then((error) {
                                if (error != null) {
                                  snackBarWidget(
                                    context: context, title: error, isError: true);
                                } else {
                                   Navigator.pushNamed(
                                    context,
                                   '/HomePage',
                                    arguments: FirebaseAuth.instance.currentUser,
                                  );

                                }
                              }); 
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 69, 42, 16),
                          foregroundColor: Colors.white, 
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Entrar'),
                          ],
                        ),
                      ),
                      TextButton(
                        child: const Text("Ainda não tem conta? Registre-se",
                        style: TextStyle(color: Color.fromARGB(255, 69, 42, 16)),),
                        onPressed: () {
                          Navigator.pushNamed(context, "/loginRegister");
                        },
                      )
                    ],
                  ))
            ],
          ),
        )));
  }
}