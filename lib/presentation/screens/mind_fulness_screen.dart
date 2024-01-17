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
          //print("Ejercicios: $snapshot");
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

            // Mapea todos los ejercicios a las URL de las imágenes
            List<String> exerciseImageURLs = allExercises.map((exercise) {
              // Si el tipo es "breathing", usa la imagen predeterminada
              if (exercise.type == 'meditation') {
                return 'lib/assets/images/breathing.png';
              }
              // Si la imagen no es nula, usa la URL del ejercicio
              return exercise.image ?? '';
            }).toList();

            // Ejemplo: Crear un CarouselSlider con las imágenes
            return CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
              ),
              items: exerciseImageURLs.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(url, fit: BoxFit.cover),
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
