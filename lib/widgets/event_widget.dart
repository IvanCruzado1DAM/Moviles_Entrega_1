import 'package:flutter/material.dart';
class EventWidget extends StatefulWidget {
  final String text1;
  final String text2;
  final String imageUrl;

  EventWidget({
    required this.text1,
    required this.text2,
    required this.imageUrl,
  });

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<EventWidget> {
  bool expandText = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 200, 239, 156),
          border: Border.all(
            color: const Color(0xFF4CAF50),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Contenedor para la imagen
                Container(
                  width: 80, // Ancho de la imagen
                  height: 80, // Alto de la imagen
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: NetworkImage('https://mindcare.allsites.es/public/images/asco.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10), // Espacio entre la imagen y el texto

                // Columna para los textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
