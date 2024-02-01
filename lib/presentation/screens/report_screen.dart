import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:mindcare/services/user_services.dart';

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

  void _generateAndSavePDF() {
    // Lógica para generar y guardar el PDF en el teléfono
    // (puedes utilizar alguna librería para la generación de PDF, como pdf or pdf_flutter)
  }

  void _generateAndSendPDF() async {
    final MailOptions mailOptions = MailOptions(
      body: 'Mindcare.',
      subject: 'PDF de los informes',
      recipients: [
        userEmail,
      ],
      isHTML: true,
      attachments: [
        'lib/assets/report.pdf',
      ],
    );

    try {
      await FlutterMailer.send(mailOptions);
    } catch (error) {
      print('Error al enviar el correo: $error');
    }
  }

  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
