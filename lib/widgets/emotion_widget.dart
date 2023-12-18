import 'package:flutter/material.dart';

class MyCustomWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final String imageUrl;

  MyCustomWidget({
    required this.text1,
    required this.text2,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 241, 173, 171),
          border: Border.all(
            color: const Color(0xFFFF4500),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Contenedor para la imagen
            Container(
              width: 80, // Ancho de la imagen
              height: 80, // Alto de la imagen
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10), // Espacio entre la imagen y el texto

            // Columna para los textos
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  text2,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmotionWidget extends StatelessWidget {
  final String texto1;
  final String texto2;
  final String img1;

  EmotionWidget({
    required this.texto1,
    required this.texto2,
    required this.img1,
  });
  @override
  Widget build(BuildContext context) {
    return MyCustomWidget(
      text1: texto1,
      text2: texto2,
      imageUrl: img1,
    );
  }
}
