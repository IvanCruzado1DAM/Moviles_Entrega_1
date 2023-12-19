import 'package:flutter/material.dart';
import 'package:mindcare/models/elements.dart';

import 'package:mindcare/services/element_srervices.dart';


class EmotionRegisterScreen extends StatefulWidget {
  const EmotionRegisterScreen({Key? key});

  @override
  State<EmotionRegisterScreen> createState() => _EmotionRegisterScreenState();
}

class _EmotionRegisterScreenState extends State<EmotionRegisterScreen> {
  int _selectedIndex = 0;
  List<ElementData> emotions = [];
  final ElementService _elementService = ElementService();

  @override
  void initState() {
    super.initState();
    print('initState() ejecutado');
    _cargarMoods();
  }

  Future<void> _cargarMoods() async {
  List<ElementData> elements = await _elementService.getEmotions();
  setState(() {
    emotions = elements;
  });
  print(emotions);

}


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.all(10),
                    child: Image.network(
                      emotions[index].image,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
