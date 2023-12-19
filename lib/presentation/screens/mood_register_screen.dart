import 'package:flutter/material.dart';
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/presentation/screens/user_screen.dart';
import 'package:mindcare/services/element_srervices.dart';
import 'package:mindcare/services/user_services.dart';

class MoodRegisterScreen extends StatefulWidget {
  const MoodRegisterScreen({super.key});

  @override
  State<MoodRegisterScreen> createState() => _MoodRegisterScreenState();
}

class _MoodRegisterScreenState extends State<MoodRegisterScreen> {
  // ignore: non_constant_identifier_names
  int? mood_id;
  final ElementService _elementService = ElementService();
  // ignore: unused_field
  late List<ElementData> _loadedElements;
  String? _selectedDescription;

  @override
  void initState() {
    super.initState();
    _loadElements();
  }

  Future<void> _loadElements() async {
    try {
      dynamic response = await _elementService.getMoods();
      if (response != null && response is List) {
        List<ElementData> elements =
            List.from(response.whereType<Map<String, dynamic>>());
        setState(() {
          _loadedElements = elements;
        });
      } else {}
      // ignore: empty_catches
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar estado de ánimo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                hint: const Text('Selecciona un estado de ánimo'),
                value: _selectedDescription,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDescription = newValue;
                    mood_id = _getMoodId(_selectedDescription);
                  });
                },
                items: ['Estoy contento', 'Estoy muy enfadado']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              if (_selectedDescription != null)
                Image.network(
                  _getImageUrl(_selectedDescription),
                  width: 200,
                  height: 250,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedDescription != null && mood_id != null
                    ? () async {
                        DateTime now = DateTime.now();
                        DateTime date = DateTime(now.year, now.month, now.day);
                        try {
                          String result = await ElementService().newElement(
                            UserService.userId,
                            'u',
                            'mood',
                            mood_id: mood_id!,
                            date.toString(),
                          );

                          if (result == 'success') {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Estado de ánimo añadido con éxito'),
                              ),
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserScreen(),
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Hubo un error al añadir un estado de ánimo',
                                ),
                              ),
                            );
                          }
                          // ignore: empty_catches
                        } catch (error) {}
                      }
                    : null,
                child: const Text('Añadir Estado de ánimo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? _getMoodId(String? description) {
    if (description == 'Estoy contento') {
      return 2;
    } else if (description == 'Estoy muy enfadado') {
      return 1;
    }
    return null;
  }

  String _getImageUrl(String? description) {
    if (description == 'Estoy contento') {
      return 'https://mindcare.allsites.es/public/images/alegria.png';
    } else if (description == 'Estoy muy enfadado') {
      return 'https://mindcare.allsites.es/public/images/ira.png';
    }
    return '';
  }
}
