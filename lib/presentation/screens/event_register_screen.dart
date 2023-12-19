import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindcare/presentation/screens/user_screen.dart';
import 'package:mindcare/services/element_srervices.dart';
import 'package:mindcare/services/user_services.dart';

class EventRegisterScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const EventRegisterScreen({Key? key}) : super(key: key);

  @override
  State<EventRegisterScreen> createState() => _EventRegisterScreenState();
}

class _EventRegisterScreenState extends State<EventRegisterScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '¿Qué te ha ocurrido hoy?',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Fecha del Evento:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: const Text('Seleccionar Fecha y Hora'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, introduce una descripción'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  String result = await ElementService().newElement(
                    UserService.userId,
                    'u',
                    'event',
                    _selectedDate.toString(),
                    description: _descriptionController.text,
                  );

                  if (result == 'success') {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserScreen()),
                    );
                  } else {
                    const Text('Hubo un error al añadir un evento');
                  }
                }
              },
              child: const Text('Añadir Evento'),
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    // Selección de fecha
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2024),
    );

    // Si la fecha se seleccionó, procede a seleccionar la hora
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      // Si la hora también se seleccionó, actualiza el estado con la fecha y hora seleccionadas
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _selectedDate = selectedDateTime; // Actualiza _selectedDate si es necesario
        });
      }
    }
  }

}
