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
  int _selectedIndex = 0;
  int mood_id = 0;
  final ElementService _elementService = ElementService();
  List<ElementData> _loadedElements = [];
  List<String> finalImages = [];

  @override
  void initState() {
    super.initState();
    _loadElements();
  }

  Future<void> _loadElements() async {
    try {
      List<ElementData> elements = await _elementService.getMoods();
      setState(() {
        _loadedElements = elements;
      });
      // ignore: empty_catches
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar estado de ánimo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 500,
          height: 600,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (ElementData image in _loadedElements)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      width: 200,
                      height: 250,
                      margin: EdgeInsets.all(10),
                      child: SelectTableImage(
                          isSelected: _selectedIndex == mood_id,
                          imageAsset: image.image,
                          onTap: (selectedIndex) {
                            setState(() {
                              print(_selectedIndex);
                              if (image.description == 'Estoy contento') {
                                mood_id = 2;
                              } else {
                                mood_id = 1;
                              }
                              _selectedIndex = image.id;
                            });
                          }),
                    )
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    DateTime date = DateTime(now.year, now.month, now.day);
                    String result = await ElementService().newElement(
                      UserService.userId,
                      'u',
                      'mood',
                      mood_id: 1,
                      date.toString(),
                    );

                    if (result == 'success') {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserScreen()),
                      );
                    } else {
                      print(result);
                      const Text('Hubo un error al añadir un estado de ánimo');
                    }
                  },
                  child: const Text('Añadir Estado de ánimo'))
            ],
          ),
        ),
      ),
    );
  }
}

class SelectTableImage extends StatelessWidget {
  const SelectTableImage(
      {super.key,
      required this.isSelected,
      required this.imageAsset,
      required this.onTap});
  final bool isSelected;
  final String imageAsset;
  final void Function(String imageAsset) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(imageAsset),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 3,
                  color: isSelected ? Colors.green : Colors.transparent)),
          child: Image.network(imageAsset),
        ),
      ),
    );
  }
}
