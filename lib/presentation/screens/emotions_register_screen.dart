import 'package:flutter/material.dart';
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/presentation/screens/user_screen.dart';
import 'package:mindcare/services/element_srervices.dart';
import 'package:mindcare/services/user_services.dart';
import 'package:intl/intl.dart';

class EmotionRegisterScreen extends StatefulWidget {
  const EmotionRegisterScreen({Key? key});

  @override
  State<EmotionRegisterScreen> createState() => _EmotionRegisterScreenState();
}

class _EmotionRegisterScreenState extends State<EmotionRegisterScreen> {
  int _selectedIndex = 0;
  List<ElementData> emotions = [];
  final ElementService _elementService = ElementService();
  int _selectedItemIndex = -1;
  int selectedEmotionId = 0;

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    List<ElementData> elements = await _elementService.getEmotions();
    setState(() {
      emotions = elements;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      selectedEmotionId = emotions[index].id;
    });
  }

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Emoción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Moods disponibles:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: emotions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedItemIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedItemIndex == index
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              emotions[index].image,
                            ),
                            if (_selectedItemIndex == index)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 1, 27, 171),
                                    width: 3,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 2),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: const Text('Seleccionar Fecha y Hora'),
            ),
            const SizedBox(height: 2),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_selectedItemIndex >= 0 &&
                      emotions.isNotEmpty &&
                      emotions.length > _selectedItemIndex) {
                    selectedEmotionId =
                        emotions[_selectedItemIndex].id;


                    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate);

                    String result = await ElementService().newElement(
                      UserService.userId,
                      'u',
                      'emotion',
                      formattedDate,
                      emotion_id: selectedEmotionId,
                    );

                    if (result == 'success') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Hubo un error al añadir una emoción',
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Seleccione una emoción'),
                      ),
                    );
                  }
                } catch (e) {
                  print('Excepción al añadir emoción: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Hubo un error al añadir una emoción',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Añadir Emoción'),
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

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2024),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
}
