import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mindcare/models/exercises.dart';
import 'package:mindcare/services/exercise.services.dart';

class MindFulnessScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MindFulnessScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final ExerciseService exerciseService = ExerciseService();

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(16, 239, 109, 8), Colors.blue.shade900],
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
                    allListExercises: allExercises, type: exerciseTypes[index]);
              },
            );
          }
        },
      ),
    ));
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

class _CarSliderState extends State<CarSlider> {
  int currentIndex = 0;
  late final List<ExerciseData> exercises;

  @override
  void initState() {
    super.initState();
    exercises = widget.allListExercises
        .where((element) => element.type == widget.type)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.type,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3.0),
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.19,
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
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.asset(
                    'lib/assets/images/breathing.jpg',
                    fit: BoxFit.cover,
                  ),
                );
              },
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
