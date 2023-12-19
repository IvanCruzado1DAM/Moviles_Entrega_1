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
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  bool expandText1 = false;

  @override
  Widget build(BuildContext context) {
    String displayText1 = expandText1
        ? widget.text1
        : (widget.text1.length > 15 ? '${widget.text1.substring(0, 15)}...' : widget.text1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 200, 239, 156),
          border: Border.all(
            color: const Color(0xFF4CAF50),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8), // Nuevo espacio interno
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('lib/assets/images/sin_imagen.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayText1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),      
                        Text(
                          widget.text2,                       
                        ),
                        const SizedBox(height: 4),                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.text1.length > 15 && !expandText1)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    expandText1 = true;
                                  });
                                },
                                child: const Text('Leer más'),
                              ),
                            if (expandText1)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    expandText1 = false;
                                  });
                                },
                                child: const Text('Ver menos'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
