import 'package:flutter/material.dart';
import 'package:mindcare/models/users.dart';
import 'package:mindcare/services/user_services.dart';

class GraficaScreen extends StatefulWidget {
  @override
  _GraficaScreenState createState() => _GraficaScreenState();
}

class _GraficaScreenState extends State<GraficaScreen> {
  late List<UserData> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      List<UserData> users = await UserService().getUsers();
      setState(() {
        _usuarios = users;
      });
    } catch (error) {
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Lista de Usuarios:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15.0), // Espacio de separación
              if (_usuarios.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<UserData>(
                    isExpanded: true,
                    value: _usuarios.first,
                    onChanged: (UserData? newValue) {
                      if (newValue != null) {
                        // Lógica para manejar el cambio de usuario seleccionado
                      }
                    },
                    items: _usuarios.map((UserData user) {
                      return DropdownMenuItem<UserData>(
                        value: user,
                        child: Text(user.getName()!),
                      );
                    }).toList(),
                  ),
                ),
              if (_usuarios.isEmpty)
                const Center(child: CircularProgressIndicator()), // Indicador de carga si no hay usuarios cargados
            ],
          ),
        ),
      ),
    );
  }
}
