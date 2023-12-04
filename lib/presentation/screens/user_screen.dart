// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mindcare/presentation/screens/login_screen.dart';

void main() => runApp(const UserScreen());

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _UserScreenState(),
    );
  }
}

class _UserScreenState extends StatefulWidget {
  const _UserScreenState({Key? key});

  @override
  State<_UserScreenState> createState() => __UserScreenState();
}

class BackGround extends StatelessWidget {
  const BackGround({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 254, 254, 254), Colors.white],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
    );
  }
}

class __UserScreenState extends State<_UserScreenState> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MainPanel(),
    ExplorePanel(),
    AccountPanel(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
        title: _selectedIndex == 0
            ? const Text('Listado de tarjetas')
            : _selectedIndex == 1
                ? const Text('Explorar')
                : const Text('Perfil'),
      ),
      body: Stack(
        children: [
          const BackGround(),
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          if (_selectedIndex == 0)
            const Positioned(
              top: 16.0,
              left: 16.0,
              child: Text(
                'Listado de tarjetas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Diario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class MainPanel extends StatelessWidget {
  const MainPanel({Key? key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              // Mostrar las opciones al hacer clic en el botón
              _mostrarOpciones(context);
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _mostrarOpciones(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOpcion(context, 'Estado de ánimo'),
            _buildOpcion(context, 'Emoción'),
            _buildOpcion(context, 'Eventos'),
          ],
        );
      },
    );
  }

  Widget _buildOpcion(BuildContext context, String texto) {
    return ListTile(
      title: Text(texto),
      onTap: () {
        // Lógica a ejecutar cuando se selecciona una opción
        Navigator.pop(context); // Cerrar el modal
        // Puedes agregar más lógica aquí según la opción seleccionada
      },
    );
  }
}

class ExplorePanel extends StatelessWidget {
  const ExplorePanel({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Explorar',
      ),
    );
  }
}

class AccountPanel extends StatelessWidget {
  const AccountPanel({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Perfil',
      ),
    );
  }
}
