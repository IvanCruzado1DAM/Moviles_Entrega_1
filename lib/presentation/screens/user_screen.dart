// ignore_for_file: use_key_in_widget_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/presentation/screens/emotions_register_screen.dart';
import 'package:mindcare/presentation/screens/event_register_screen.dart';
import 'package:mindcare/presentation/screens/login_screen.dart';
import 'package:mindcare/presentation/screens/mind_fulness_screen.dart';
import 'package:mindcare/presentation/screens/mood_register_screen.dart';
import 'package:mindcare/services/element_srervices.dart';
import 'package:mindcare/widgets/emotion_widget.dart';
import 'package:mindcare/widgets/event_widget.dart';
import 'package:mindcare/widgets/mood_widget.dart';

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(16, 239, 109, 8), Colors.blue.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class __UserScreenState extends State<_UserScreenState> {
  int _selectedIndex = 0;
  final ElementService _elementService = ElementService();
  List<ElementData> _loadedElements = [];

  @override
  void initState() {
    super.initState();
    _loadElements();
  }

  Future<void> _loadElements() async {
    try {
      List<ElementData> elements = await _elementService.getElements();
      setState(() {
        _loadedElements = elements;
      });
    } catch (error) {
      print('Error al cargar elementos: $error');
    }
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
        backgroundColor: Colors.blue,
        leading: Row(
          children: [
            const SizedBox(
              width: 10.0, 
            ),
            const Text(
              'Exit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded( 
              child: IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                iconSize: 24.0, 
              ),
            ),
          ],
        ),
        title: _selectedIndex == 0
            ? const Row(
                children: [
                  SizedBox(
                    width: 8.0, 
                  ),
                  Text('Listado de tarjetas'),
                  Spacer(),
                ],
              )
            : _selectedIndex == 1
              ? const Row(
                  children: [
                    SizedBox(width: 8.0),
                    Text('MindFulness'),
                    Spacer(),
                  ],
                )
              : const Row(
                  children: [
                    SizedBox(width: 8.0), 
                    Text('Perfil'),
                    Spacer(),
                  ],
                ),
            ),
      body: Stack(
        children: [
          const BackGround(),
          Center(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _loadedElements.clear();
                });
                await _loadElements();
              },
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  // Widget para el índice 0 (Diario)
                  _buildDiarioWidget(),
                  // Widget para el índice 1 (Mindfulness)
                  const MindFulnessPanel(),
                  // Widget para el índice 2 (Perfil)
                  const AccountPanel(),
                ],
              ),
            ),
          ),
          if (_selectedIndex == 0) // Only show FloatingActionButton for Diario
            const MainPanel(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 86, 189, 227),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Diario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'MindFulness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.red,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDiarioWidget() {
    return ListView.builder(
      itemCount: _loadedElements.length,
      itemBuilder: (context, index) {
        if (_loadedElements[index].type == 'mood') {
          MoodWidget moodWidget = MoodWidget(
            text1: _loadedElements[index].description,
            text2: "Fecha: ${_loadedElements[index].createdAt}",
            imageUrl: _loadedElements[index].image,
          );
          return Column(
            children: [
              const SizedBox(height: 10),
              moodWidget,
            ],
          );
        } else if (_loadedElements[index].type == 'event') {
          EventWidget eventWidget = EventWidget(
            text1: _loadedElements[index].description,
            text2: "Fecha: ${_loadedElements[index].date}",
            imageUrl: _loadedElements[index].image,
          );
          return Column(
            children: [
              const SizedBox(height: 10),
              eventWidget,
            ],
          );
        } else if (_loadedElements[index].type == 'emotion') {
          EmotionWidget emotionWidget = EmotionWidget(
            texto1: _loadedElements[index].name,
            texto2: "Fecha: ${_loadedElements[index].createdAt}",
            img1: _loadedElements[index].image,
          );
          return Column(
            children: [
              const SizedBox(height: 10),
              emotionWidget,
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class MainPanel extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
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
        Navigator.pop(context);
        if (texto == 'Eventos') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EventRegisterScreen()),
          );
        } else if (texto == 'Estado de ánimo') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MoodRegisterScreen()));
        } else if (texto == 'Emoción') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EmotionRegisterScreen()));
        }
      },
    );
  }
}

class MindFulnessPanel extends StatelessWidget {
  const MindFulnessPanel({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: MindFulnessScreen(),
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
