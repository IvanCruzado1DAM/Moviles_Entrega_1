// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/users.dart';
import 'package:mindcare/presentation/screens/admin_screen.dart';
import 'package:mindcare/presentation/screens/login_screen.dart';
import 'package:mindcare/presentation/screens/user_screen.dart';
import 'package:mindcare/services/user_services.dart';

// ignore_for_file: library_private_types_in_public_api
class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [BackGround(), Content()],
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  _contentState createState() => _contentState();
}

// ignore: camel_case_types
class _contentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'MindCare',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Image.asset(
            'lib/assets/images/mindCare.png',
            width: 100,
          ),
          const SizedBox(
            height: 15,
          ),
          const Data(),
        ],
      ),
    );
  }
}

class Data extends StatefulWidget {
  // ignore: use_super_parameters
  const Data({Key? key}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  String username = "";
  String useremail = "";
  String userpassword = "";
  String userpasswordconf = "";
  bool isObscure = true;
  bool isObscureConf = true;
  _DataState getInstance() {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nombre',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Introduce tu nombre'),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              }),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Email',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Introduce el email'),
              onChanged: (value) {
                setState(() {
                  useremail = value;
                });
              }),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Contraseña',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              obscureText: isObscure,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Introduce tu contraseña aquí',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    onPressed: () {
                      setState(() {
                        isObscure == true
                            ? isObscure = false
                            : isObscure = true;
                      });
                    },
                  )),
              onChanged: (value) {
                setState(() {
                  userpassword = value;
                });
              }),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Confirmar contraseña',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              obscureText: isObscureConf,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Introduce tu contraseña de nuevo aquí',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    onPressed: () {
                      setState(() {
                        isObscureConf == true
                            ? isObscure = false
                            : isObscure = true;
                      });
                    },
                  )),
              onChanged: (value) {
                setState(() {
                  userpasswordconf = value;
                });
              }),
          const SizedBox(
            height: 25,
          ),
          Buttons(dataState: this),
        ],
      ),
    );
  }
}

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.blue.shade300, Colors.blue],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      )),
    );
  }
}

class Remember extends StatefulWidget {
  const Remember({super.key});

  @override
  _RememberState createState() => _RememberState();
}

class _RememberState extends State<Remember> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        const Text('Recordarme'),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text('¿Olvidaste tu contraseña?'),
        ),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  final UserService userService = UserService();
  final _DataState dataState;

  // ignore: use_super_parameters
  Buttons({required this.dataState, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              try {
                if (dataState.useremail == '' || dataState.userpassword == '') {
                  mostrarAlertDialog(context);
                } else if (dataState.userpassword !=
                    dataState.userpasswordconf) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Las contraseñas no coinciden.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  await userService.register(
                    dataState.username,
                    dataState.useremail,
                    dataState.userpassword,
                    dataState.userpasswordconf,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Usuario registrado con éxito'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (error) {
                // ignore: avoid_print
                print('Error en el registro: $error');
                // Agregar manejo de errores más específico según la necesidad
              }
            },
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Color(0xff142047)),
            ),
            child: const Text(
              'Registrar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> mostrarAlertDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ERROR'),
              content: const Text('HAS INTRODUCIDO CAMPOS VACÍOS'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Cerrar el AlertDialog y devolver false
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Cerrar el AlertDialog y devolver true
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        ) ??
        false; // Si se cierra el AlertDialog sin seleccionar nada, devolver false
  }
}
