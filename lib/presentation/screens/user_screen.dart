import 'package:flutter/material.dart';
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/presentation/screens/emotions_register_screen.dart';
import 'package:mindcare/presentation/screens/event_register_screen.dart';
import 'package:mindcare/presentation/screens/login_screen.dart';
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
    );
  }
}

class __UserScreenState extends State<_UserScreenState> {
  int _selectedIndex = 0;
  ElementService _elementService = ElementService();
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
            ? Row(
                children: [
                  const Text('Listado de tarjetas'),
                  const Spacer(),
                  
                ],
              )
            : _selectedIndex == 1
                ? const Text('Explorar')
                : const Text('Perfil'),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _loadedElements.length,
                      itemBuilder: (context, index) {
                        /*_loadedElements.sort((a, b) {
                      if (a.type != 'event' && b.type != 'event') {                       
                        return b.createdAt.compareTo(a.createdAt);
                      } else if (a.type == 'event' && b.type != 'event') {                        
                        if (a.date != null && b.createdAt != null) {
                          return b.createdAt.compareTo(a.date!);
                        }
                      } else if (a.type != 'event' && b.type == 'event') {
                        if (b.date != null && a.createdAt != null) {
                          return b.date!.compareTo(a.createdAt);
                        }
                      } else if (a.type == 'event' && b.type == 'event') {
                        if (a.date != null && b.date != null) {
                          return b.date!.compareTo(a.date!);
                        }
                      }
                      return 0; 
                    });*/

                        if (_loadedElements[index].type == 'mood') {
                          MoodWidget moodWidget = MoodWidget(
                            text1: _loadedElements[index].description,
                            text2: "Fecha: " +
                                _loadedElements[index].createdAt.toString(),
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
                            text2: "Fecha: " +
                                _loadedElements[index].date.toString(),
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
                            texto2: "Fecha: " +
                                _loadedElements[index].createdAt.toString(),
                            img1: _loadedElements[index].image,
                          );
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              emotionWidget,
                            ],
                          );
                        } else {
                          return SizedBox(); 
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const MainPanel(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 86, 189, 227), 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
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
        }
        else if (texto == 'Emoción') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EmotionRegisterScreen()));
        }
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
