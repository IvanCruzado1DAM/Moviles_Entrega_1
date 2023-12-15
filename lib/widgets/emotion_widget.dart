import 'package:flutter/material.dart';

class emotion_widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10), // Espacio horizontal a ambos lados
    child: Container(
      width: MediaQuery.of(context).size.width, // Ancho de la pantalla
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFFF4500),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
}