import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mindcare/models/users.dart';
import 'package:mindcare/presentation/screens/login_screen.dart';
import 'package:mindcare/services/user_services.dart';

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
      'Index 1: Explorar',
      style: optionStyle,
    ),
    Text(
      'Index 2: Perfil',
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
      print('Error cargando usuarios: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: const Text('Lista Usuarios'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Lógica para volver atrás
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: _selectedIndex == 0
            ? _buildUsuariosSlidable(_usuarios)
            : _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Panel Admin',
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

    return Slidable(
      key: ValueKey(usuario.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async {
              // Muestra el cuadro de diálogo de confirmación
              bool confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                        '¿Seguro que quieres eliminar a este usuario?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // No confirmado
                        },
                        child: const Text('Volver'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirmado
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  );
                },
              );

              // Si el usuario confirma, procede con la eliminación
              if (confirm == true) {
                try {
                  UserService userService = UserService();
                  await userService.postDeleteUser(usuario.id.toString()).then(
                    (result) {
                      if (result == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario eliminado con éxito'),
                          ),
                        );
                      } else {
                        print(usuario.id.toString());
                      }
                    },
                  );

                  // Actualiza la lista de usuarios después de eliminar
                  _loadUsers();
                } catch (error) {
                  print('Error eliminando el usuario: $error');

                  // Verifica si el widget todavía está montado antes de mostrar el SnackBar
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al eliminar el usuario'),
                      ),
                    );
                  }
                }
              }
            },
            backgroundColor: const Color(0xFFFE4A49),
            icon: Icons.delete,
            label: 'Eliminar',
          ),
          SlidableAction(
            onPressed: (BuildContext context) {
              // Lógica para editar el usuario
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Editar ${usuario.getName()!}')),
              );
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
          SlidableAction(
            flex: 2,
            onPressed: (BuildContext context) {
              // Lógica para desactivar el usuario
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Desactivar ${usuario.getName()!}')),
              );
            },
            backgroundColor: const Color(0xFFFE4A49),
            icon: Icons.archive,
            label: 'Desactivar',
            // Ajusta el tamaño de la letra
          ),
          SlidableAction(
            flex: 2,
            onPressed: (BuildContext context) {
              // Lógica para activar el usuario
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Activar ${usuario.getName()!}')),
              );
            },
            backgroundColor: Colors.green, // Cambiado a verde
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
