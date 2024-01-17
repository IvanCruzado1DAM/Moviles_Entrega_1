import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mindcare/models/exercises.dart';
import 'package:mindcare/services/exercise.services.dart'; // Asegúrate de importar el servicio correcto

class MindFulnessScreen extends StatelessWidget {
  const MindFulnessScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final ExerciseService _exerciseService = ExerciseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindFulness Screen'),
      ),
      body: FutureBuilder<List<String>>(
        // Utiliza FutureBuilder para manejar operaciones asincrónicas
        future: _exerciseService
            .getExerciseImageURLs(), // Cambia a la función correcta que obtiene las URLs de las imágenes
        builder: (context, snapshot) {
          print(_exerciseService.getExercises());

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
            // Aquí puedes usar la lista de URLs de las imágenes
            List<String> exerciseImageURLs = snapshot.data!;

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
