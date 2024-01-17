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
      appBar: AppBar(),
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
            print('Y ESTOOO $allExercises');
            // Filtrar los ejercicios tipo 'breathing'
            List<ExerciseData> breathingExercises = allExercises
                .where((exercise) => exercise.type == 'Relaxation')
                .toList();

            // Ejemplo: Crear un CarouselSlider con las imágenes
            print('A VEEE $breathingExercises');
            return CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                aspectRatio: 1.0,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
              ),
              items: breathingExercises.map((exercise) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        exercise.image ?? 'lib/assets/images/breathing.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
