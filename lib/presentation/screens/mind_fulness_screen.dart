import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mindcare/models/exercises.dart';
import 'package:mindcare/services/exercise.services.dart';
import 'detalles_ejercicio.dart';

class MindFulnessScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MindFulnessScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final ExerciseService exerciseService = ExerciseService();
    late Map<int, bool> exerciseStarStates;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(16, 239, 109, 8),
              Colors.blue.shade900
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<ExerciseData>>(
          future: exerciseService.getExercises(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error al cargar ejercicios: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No hay ejercicios disponibles'),
              );
            } else {
              List<ExerciseData> allExercises = snapshot.data!;
              List<String> exerciseTypes = [];
              for (var types in allExercises) {
                if (!exerciseTypes.contains(types.type)) {
                  exerciseTypes.add(types.type);
                }
              }

              const SizedBox();

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: exerciseTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  return CarSlider(
                    allListExercises: allExercises,
                    type: exerciseTypes[index],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CarSlider extends StatefulWidget {
  final List<ExerciseData> allListExercises;
  final String type;

  const CarSlider({
    super.key,
    required this.allListExercises,
    required this.type,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CarSliderState createState() => _CarSliderState();
}

bool estrellaRellenada = false;
int currentIndex = 0;
late final List<ExerciseData> exercises;
ExerciseService es = ExerciseService();

class _CarSliderState extends State<CarSlider> {
  late final List<ExerciseData> exercises;
  ExerciseService es = ExerciseService();

  // Mapa para almacenar los estados de la estrella para cada ejercicio
  late Map<int, bool> exerciseStarStates;

  @override
  void initState() {
    super.initState();
    exercises = widget.allListExercises
        .where((element) => element.type == widget.type)
        .toList();

    // Inicializa el mapa con todos los estados de la estrella como vacíos
    exerciseStarStates = {for (var exercise in exercises) exercise.id: false};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.type,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3.0),
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.16,
            aspectRatio: 1.0,
            enableInfiniteScroll: false,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: exercises.map((exercise) {
            return GestureDetector(
              onTap: () async {              
                setState(() {
                  exerciseStarStates[exercise.id] =
                      !exerciseStarStates[exercise.id]!;
                });
              
                ExerciseData ejercicio = await es.getExerciseById(exercise.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetalleEjercicio(ejercicio: ejercicio),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image.network(
                      exercise.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 8.0,
                    left: 8.0,
                    right: 8.0,
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        exercise.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Icon(
                      exerciseStarStates[exercise.id]!
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: exercises.map((exercise) {
            int index = exercises.indexOf(exercise);
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == currentIndex ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
