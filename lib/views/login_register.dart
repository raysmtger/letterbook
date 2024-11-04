import 'package:flutter/material.dart';
import 'package:letterbook/services/authentication_service.dart';
import 'package:letterbook/widgets/snack_bar_widget.dart';
import 'package:letterbook/widgets/text_field_widget.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registrar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 69, 42, 16),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(199, 242, 214, 196),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/LetterBook (1)-Photoroom.png',
                width: 200, height: 200
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: "Nome",
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
                        validator: (value) => requiredValidator(value, "o nome"),
                      ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: "Email",
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          _authService
                              .registerUser(
                                name: name,
                                email: email,
                                password: password,
                              )
                              .then((value) {
                            if (value != null) {
                              snackBarWidget(
                                context: context,
                                title: value,
                                isError: true
                              );
                            } else{
                              snackBarWidget(
                                context: context, 
                                title: "Cadastro efetuado com sucesso!",
                                isError: false
                                );

                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 69, 42, 16),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Registrar'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}