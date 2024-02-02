import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:mindcare/services/user_services.dart';
import 'package:path_provider/path_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _includeEmotion = false;
  bool _includeMood = false;
  bool _includeEvent = false;
  final String userEmail = UserService.currentUserEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(16, 239, 109, 8),
                  Colors.blue.shade900
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () => _selectStartDate(context),
                          child: Text(
                              'Fecha de inicio: ${_formattedDate(_startDate)}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () => _selectEndDate(context),
                          child:
                              Text('Fecha final: ${_formattedDate(_endDate)}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Tipo de elementos:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _includeEmotion,
                          onChanged: (value) {
                            setState(() {
                              _includeEmotion = value!;
                            });
                          },
                        ),
                        const Text('Emoción'),
                        Checkbox(
                          value: _includeMood,
                          onChanged: (value) {
                            setState(() {
                              _includeMood = value!;
                            });
                          },
                        ),
                        Checkbox(
                          value: _includeEvent,
                          onChanged: (value) {
                            setState(() {
                              _includeEvent = value!;
                            });
                          },
                        ),
                        const Text('Evento'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _generateAndSavePDF();
                          },
                          child: const Text('Generar PDF'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            _generateAndSendPDF();
                          },
                          child: const Text('Enviar PDF'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _generateAndSavePDF() async {
    String fileName = 'report.pdf';

    // Obtiene el directorio de documentos de la aplicación
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

    // Crea una subcarpeta llamada 'pdfs' (puedes cambiar el nombre)
    Directory pdfDirectory = Directory('${appDocumentsDirectory.path}/pdfs');
    if (!pdfDirectory.existsSync()) {
      pdfDirectory.createSync(recursive: true);
    }

    // Combina el directorio de documentos con la carpeta y el nombre del archivo
    String pdfFilePath = '${pdfDirectory.path}/$fileName';

    // Verifica la existencia del archivo
    bool pdfExists = File(pdfFilePath).existsSync();

    if (pdfExists) {
      print('El archivo PDF existe en la ruta especificada.');
      print(pdfFilePath);
      // Aquí puedes proceder con la lógica para generar y guardar el PDF
    } else {
      print('El archivo PDF no existe. Creándolo manualmente...');
      try {
        File(pdfFilePath).createSync(recursive: true);
        print('El archivo PDF fue creado exitosamente en: $pdfFilePath');

        // IVAN, haz que este metodo devuelva return pdffilepath y lo metes como parametro en el _generateAndSendPDF
      } catch (error) {
        print('Error al crear el archivo: $error');
      }
    }
  }

  Future<void> _generateAndSendPDF() async {
    try {
      final MailOptions mailOptions = MailOptions(
        body: 'Mindcare.',
        subject: 'PDF de los informes',
        recipients: [
          userEmail,
        ],
        // el attachment es la url del telefono donde se descarga, hace falta porque lo pide
        attachments: [],
        isHTML: false,
      );

      await FlutterMailer.send(mailOptions);
    } catch (error) {
      print('Error al enviar el correo: $error');
    }
  }

  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
