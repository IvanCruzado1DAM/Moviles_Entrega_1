import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mindcare/models/exercises.dart';
import 'package:mindcare/services/exercise.services.dart';

class MindFulnessScreen extends StatelessWidget {
  const MindFulnessScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final ExerciseService _exerciseService = ExerciseService();

    return Scaffold(
      body: FutureBuilder<List<ExerciseData>>(
        future: _exerciseService.getExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print('Error al cargar ejercicios: ${snapshot.error}');
            return Center(
              child: Text('Error al cargar ejercicios: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay ejercicios disponibles'),
            );
          } else {
            // Obtén todos los ejercicios
            List<ExerciseData> allExercises = snapshot.data!;
            List<String> exerciseTypes = [];
            for (var types in allExercises) {
              if (!exerciseTypes.contains(types.type)) {
                exerciseTypes.add(types.type);
              }
            }
            print('Y ESTOOO $allExercises');

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
    );
  }
}

class CarSlider extends StatelessWidget {
  CarSlider({
    super.key,
    required this.allListExercises,
    required this.type,
  }) : exercises =
            allListExercises.where((element) => element.type == type).toList();

  final List<ExerciseData> allListExercises;
  final List<ExerciseData> exercises;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(type),
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            aspectRatio: 1.0,
            enableInfiniteScroll: false,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
          ),
          items: exercises.map((exercise) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  // CAMBIAR ESTO A NETWORK PARA PONERLO DESDE LA BASE DE DATOS
                  child: Image.asset(
                    'lib/assets/images/breathing.jpg',
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
