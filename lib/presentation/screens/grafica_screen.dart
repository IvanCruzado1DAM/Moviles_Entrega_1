import 'package:flutter/material.dart';
import 'package:mindcare/models/users.dart';
import 'package:mindcare/services/user_services.dart';
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/services/element_srervices.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class GraficaScreen extends StatefulWidget {
  @override
  _GraficaScreenState createState() => _GraficaScreenState();
}

class _GraficaScreenState extends State<GraficaScreen> {
  late List<UserData> _usuarios = [];
  UserData? _selectedUser;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      List<UserData> users = await UserService().getUsers();
      setState(() {
        _usuarios = users;
      });
    } catch (error) {
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Aplicando desplazamiento vertical a toda la pantalla
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Lista de Usuarios:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15.0),

                if (_usuarios.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<UserData>(
                      isExpanded: true,
                      value: _selectedUser,
                      onChanged: (UserData? newValue) {
                        setState(() {
                          _selectedUser = newValue;
                        });
                      },
                      items: _usuarios.map((UserData user) {
                        return DropdownMenuItem<UserData>(
                          value: user,
                          child: Text(user.getName()!),
                        );
                      }).toList(),
                    ),
                  ),
                if (_usuarios.isEmpty)
                  const Center(
                    child: CircularProgressIndicator(),
                  ), // Indicador de carga si no hay usuarios cargados
                const SizedBox(height: 10.0), // Espacio de separación
                const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Emotion: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 12,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Mood: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.circle,
                        color: Colors.blue,
                        size: 12,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Event: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0), // Espacio de separación
                _buildCharts(), // Widget para construir las gráficas
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCharts() {
    DateTime now = DateTime.now();
    List<Widget> charts = [];
    for (int i = 1; i <= 4; i++) {
      DateTime monthDate = DateTime(now.year, now.month - i);
      charts.add(_buildChartForMonth(monthDate));
    }
    return Column(
      children: charts,
    );
  }

  Widget _buildChartForMonth(DateTime monthDate) {
    String monthLabel = DateFormat('MMMM').format(monthDate);
    DateTime endDate = DateTime(monthDate.year, monthDate.month + 1, 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Text(
            'Datos de $monthLabel:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          SizedBox(
            height: 200, // Altura fija para el contenedor de la gráfica
            child: FutureBuilder<List<ElementData>>(
              future: ElementService().getElementsByIDAndMonth(
                  _selectedUser?.id.toString() ?? '', monthDate, endDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<ElementData> elements = snapshot.data ?? [];
                  if (elements.isEmpty) {
                    return Center(
                      child: Text('No hay registros para este mes'),
                    );
                  }
                  Map<String, int> typeCountMap = {};
                  elements.forEach((element) {
                    typeCountMap[element.type!] =
                        (typeCountMap[element.type] ?? 0) + 1;
                  });
                  return _buildColumnChart(typeCountMap);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildColumnChart(Map<String, int> typeCountMap) {
  final double columnWidth = 40.0; // Ancho fijo para cada columna
  final int maxCount = typeCountMap.values.isNotEmpty ? typeCountMap.values.reduce((value, element) => value > element ? value : element) : 0;
  return SizedBox(
    width: 320, // Ancho fijo para el contenedor de la gráfica
    child: CustomPaint(
      size: Size((columnWidth + 10.0) * typeCountMap.length, 200),
      painter: ColumnChartPainter(
        typeCountMap,
        40.0,
        columnWidth,
        maxCount,
      ),
    ),
  );
}
}
class ColumnChartPainter extends CustomPainter {
  final Map<String, int> typeCountMap;
  final double columnHeightFactor;
  final double columnWidth;
  final int maxCount;

  ColumnChartPainter(this.typeCountMap, this.columnHeightFactor, this.columnWidth, this.maxCount);

  @override
  void paint(Canvas canvas, Size size) {
    double startX = (size.width - (columnWidth + 10.0) * typeCountMap.length + 10.0) / 2; // Calcular la posición inicial para centrar las columnas
    typeCountMap.forEach((type, count) {
      final Paint paint = Paint()..color = _getColorByType(type);
      final double normalizedHeight = (count / maxCount) * (size.height - 20); // Normalizar la altura de la columna dentro del espacio fijo del contenedor
      canvas.drawRect(
        Rect.fromLTWH(startX, size.height - normalizedHeight, columnWidth, normalizedHeight),
        paint,
      );

      final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: count.toString(), // Mostrar el número de cada tipo
        style: TextStyle(color: Colors.black),
      ),
      textDirection: ui.TextDirection.ltr, // Establecer la dirección del texto
    );

      textPainter.layout();
      final double textX = startX + columnWidth / 2 - textPainter.width / 2; // Calcular la posición X del número
      final double textY = size.height - normalizedHeight - textPainter.height - 2; // Calcular la posición Y del número
      textPainter.paint(canvas, Offset(textX, textY));

      startX += columnWidth + 10.0;
    });
  }

  Color _getColorByType(String type) {
    switch (type) {
      case 'emotion':
        return Colors.red;
      case 'mood':
        return Colors.blue;
      case 'event':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
