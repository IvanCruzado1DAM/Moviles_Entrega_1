import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/users.dart';
import 'package:mindcare/presentation/screens/admin_screen.dart';
import 'package:mindcare/presentation/screens/register_screen.dart';
import 'package:mindcare/presentation/screens/user_screen.dart';
import 'package:mindcare/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: library_private_types_in_public_api
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
  const Data({super.key});

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  static String useremail = "";
  static String userpassword = "";
  bool isObscure = true;
  @override
  void initState() {
    super.initState();
    // Limpiar campos al iniciar la pantalla
    _clearFields();

    _loadRememberedData();
  }

  // Método para limpiar los campos
  void _clearFields() {
    setState(() {
      useremail = "";
      userpassword = "";
    });
  }

  _loadRememberedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bool isChecked = prefs.getBool('rememberMe') ?? false;
      if (isChecked) {
        useremail = prefs.getString('rememberedEmail') ?? "";
        userpassword = prefs.getString('rememberedPassword') ?? "";
      }
    });
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
                useremail = value;
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
                userpassword = value;
              }),
          const Remember(),
          const SizedBox(
            height: 30,
          ),
          Buttons(),
        ],
      ),
    );
  }

  _saveRememberedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('rememberedEmail', useremail);
    prefs.setString('rememberedPassword', userpassword);
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
        const SizedBox(width: 7.0), // Espaciado entre el checkbox y el texto
        const Expanded(
          child: Text(
            'Recordarme',
            style:
                TextStyle(fontSize: 13.0), // Puedes ajustar el tamaño del texto
          ),
        ),
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
  final UserService userservice = UserService();
  Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              userservice
                  .login(_DataState.useremail, _DataState.userpassword)
                  .then((result) {
                if (_DataState.useremail == '' ||
                    _DataState.userpassword == '') {
                  mostrarAlertDialog(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    if (result == 'success') {
                      if (UserService.userType == 'a') {
                        return const AdminScreen();
                      } else {
                        return const UserScreen();
                      }
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (result == 'Email not confirmed') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tu correo no ha sido confirmado.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (result == 'User not activated') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tu usuario no está activado.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email o contraseña incorrectos.'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      });
                    }
                    return LoginScreen();
                  }));
                }
              }).catchError((error) {
                print('Error en el inicio de sesión: $error');
              });
            },
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Color(0xff142047)),
            ),
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        const Text(
          '¿No tienes cuenta?',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: const Text(
              'Regístrate',
              style: TextStyle(
                color: Color(0xff142047),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        const SizedBox(
          height: 10,
        )
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
