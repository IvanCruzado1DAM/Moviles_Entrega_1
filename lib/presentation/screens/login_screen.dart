import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [BackGround(), Content()],
      ),
    );
  }
}

class Content extends StatefulWidget {
  @override
  _contentState createState() => _contentState();
}

class _contentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Bienvenido a tu cuenta',
            style: TextStyle(
                color: Colors.white, fontSize: 15, letterSpacing: 1.5),
          ),
          SizedBox(
            height: 5,
          ),
          Data(),
        ],
      ),
    );
  }
}

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  bool obs = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Introduce el email'),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Password',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            obscureText: obs,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Introduce tu contraseña aqui',
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    setState(() {
                      obs == true ? obs = true : obs = false;
                    });
                  },
                )),
          ),
          Remember(),
          SizedBox(
            height: 30,
          ),
          Buttons(),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
    );
  }
}

class BackGround extends StatelessWidget {
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
  @override
  _RememberState createState() => _RememberState();
}

class _RememberState extends State<Remember> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (value) {
            setState(() {
              value == false ? value = true : value = false;
            });
          },
        ),
        Text('Recordarme'),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text('¿Olvidaste tu contraseña?'),
        ),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Inicia sesión',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Color(0xff142047)),
            ),
          ),
        ),
        SizedBox(
          height: 25,
          width: double.infinity,
        ),
        Text(
          '0 entra con: ',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          height: 25,
          width: double.infinity,
        ),
        Container(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {},
            child: Text(
              'Regístrate con Google',
              style: TextStyle(
                color: Color(0xff142047),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25,
          width: double.infinity,
        ),
        Container(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {},
            child: Text(
              'Regístrate con Facebook',
              style: TextStyle(
                color: Color(0xff142047),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
