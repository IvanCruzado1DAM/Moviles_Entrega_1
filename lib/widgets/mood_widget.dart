import 'package:flutter/material.dart';

class MoodWidget extends StatefulWidget {
  final String text1;
  final String text2;
  final String imageUrl;

  MoodWidget({
    required this.text1,
    required this.text2,
    required this.imageUrl,
  });

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MoodWidget> {
  bool expandText = false;
  double containerHeight = 120.0; // Altura inicial del contenedor

  @override
  Widget build(BuildContext context) {
    String displayText1 = expandText
        ? widget.text1
        : (widget.text1.length > 15 ? '${widget.text1.substring(0, 15)}...' : widget.text1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 245, 241, 137),
          border: Border.all(
            color: const Color(0xFFFFD700),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Contenedor para la imagen
            Container(
              width: 90,
              height: 100,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Columna para los textos
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 4), // Ajuste del espacio arriba del texto
                    child: Text(
                      displayText1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),  
                  Text(
                    widget.text2,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  if (widget.text1.length > 15)
                    Align(
                      alignment: Alignment.bottomRight, // Ubica los botones en la esquina inferior derecha
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              expandText = !expandText;
                              containerHeight = expandText ? 150.0 : 120.0;
                            });
                          },
                          child: Text(
                            expandText ? 'Ver menos' : 'Leer más',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        height: containerHeight,
      ),
    );
  }
}
