import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/users.dart';
import 'package:mindcare/presentation/screens/admin_screen.dart';
import 'package:mindcare/presentation/screens/user_screen.dart';
import 'package:mindcare/services/user_services.dart';

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
  String useremail="";
  String userpassword="";
  bool isObscure = false;
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
                onChanged: (value){
                  useremail=value;
                }
          ),
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
                border: OutlineInputBorder(), 
                hintText: 'Introduce tu contraseña aquí',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    setState(() {
                      isObscure == true ? isObscure = false : isObscure = true;
                    });
                  },             
                )),
                onChanged: (value){
                  userpassword=value;
                }
                ),
          const Remember(),
          const SizedBox(
            height: 30,
          ),
          Buttons(),
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
              try{                  
                if(UserService.userType=='u'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserScreen(),
                     ),
                  );
                }else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen(),
                     ),
                  );
                }
              }catch(error) {
                print('Error al obtener los datos del usuario: $error');
              }
            },
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Color(0xff142047)),
            ),
            child: const Text(
              'Inicia sesión',
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
            onPressed: () {},
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
}
