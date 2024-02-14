import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mindcare/models/users.dart';
import 'package:mindcare/presentation/screens/login_screen.dart';
import 'package:mindcare/services/user_services.dart';
import 'package:mindcare/presentation/screens/grafica_screen.dart';

void main() => runApp(const AdminScreen());

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminScreenState(),
    );
  }
}

class AdminScreenState extends StatefulWidget {
  const AdminScreenState({Key? key});

  @override
  State<AdminScreenState> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreenState> {
  int _selectedIndex = 0;
  List<UserData> _usuarios = [];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Pantalla admin',
      style: optionStyle,
    ),
    Text(
      'Index 1: Gráficas',
      style: optionStyle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _loadUsers();
    }
  }

  void _loadUsers() async {
    try {
      UserService userService = UserService();
      List<UserData> usuarios = await userService.getUsers();
      setState(() {
        _usuarios = usuarios;
      });
    } catch (error) {
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: _selectedIndex == 0 ? const Text('Lista Usuarios') : const Text('Gráfica'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildUsuariosSlidable(_usuarios),
          GraficaScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 86, 189, 227),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Panel Admin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Gráficas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildUsuariosSlidable(List<UserData> usuarios) {
    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        return Builder(
          builder: (context) => _buildSlidable(usuarios[index], context),
        );
      },
    );
  }

  Widget _buildSlidable(UserData usuario, BuildContext context) {
    Color nombreColor = usuario.actived == 1 ? Colors.green : Colors.red;
    String nuevoNombre = '';
    return Slidable(
      key: ValueKey(usuario.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async {
              // Lógica para eliminar usuario
            },
            backgroundColor: const Color(0xFFFE4A49),
            icon: Icons.delete,
            label: 'Eliminar',
          ),
          SlidableAction(
            onPressed: (BuildContext context) async {
              // Lógica para editar usuario
            },
            backgroundColor: const Color(0xFF21B7CA),
            icon: Icons.edit,
            label: 'Editar',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (usuario.actived == 1)
            SlidableAction(
              onPressed: (BuildContext context) async {
                // Lógica para desactivar usuario
              },
              backgroundColor: const Color(0xFFFE4A49),
              icon: Icons.archive,
              label: 'Desactivar',
            ),
          if (usuario.actived == 0)
            SlidableAction(
              onPressed: (BuildContext context) async {
                // Lógica para activar usuario
              },
              backgroundColor: const Color.fromARGB(255, 47, 255, 0),
              icon: Icons.save,
              label: 'Activar',
            ),
        ],
      ),
      child: ListTile(
        title: Text(
          usuario.getName()!,
          style: TextStyle(color: nombreColor),
        ),
        subtitle: Text(usuario.email!),
      ),
    );
  }
}


