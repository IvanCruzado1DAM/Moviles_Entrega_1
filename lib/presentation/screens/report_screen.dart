import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:mindcare/services/user_services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/services/element_srervices.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

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
  late Future<Uint8List> archivoPdf;

  @override
  void initState() {
    super.initState();
    archivoPdf = _generateAndSavePDF();
  }

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
                              _updatePdf();
                            });
                          },
                        ),
                        const Text('Emoción'),
                        Checkbox(
                          value: _includeMood,
                          onChanged: (value) {
                            setState(() {
                              _includeMood = value!;
                              _updatePdf();
                            });
                          },
                        ),
                        const Text('Estado de ánimo'),
                        Checkbox(
                          value: _includeEvent,
                          onChanged: (value) {
                            setState(() {
                              _includeEvent = value!;
                              _updatePdf();
                            });
                          },
                        ),
                        const Text('Evento'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<Uint8List>(
                      future: archivoPdf,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              if (_includeEmotion ||
                                  _includeMood ||
                                  _includeEvent) {
                                Printing.layoutPdf(onLayout: (format) async {
                                  return archivoPdf; // Devuelve el PDF generado
                                });
                              } else {
                                _showNoElementSelectedDialog();
                              }
                            },
                            child: const Text('Generar PDF'),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _generateAndSendPDF();
                      },
                      child: const Text('Enviar PDF'),
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
      _updatePdf();
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
      _updatePdf();
    }
  }

 Future<Uint8List> _generateAndSavePDF() async {
  pw.Document pdf;
  final ElementService _elementService = ElementService();
  List<ElementData> elements = await _elementService.getElements();
  pdf = pw.Document();

  List<ElementData> filteredElements = elements.where((element) {
    return _shouldIncludeElement(element);
  }).toList();

  if (filteredElements.isEmpty) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
            padding: pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.red,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Text(
              'No se encontraron resultados.',
              style: pw.TextStyle(
                fontSize: 20,
                color: PdfColors.white,
              ),
            ),
            )
          );
        },
      ),
    );
  } else {
    String _getDateValue(ElementData element) {
      if (element.type == 'event') {
        return element.date != null
            ? DateFormat('dd/MM/yyyy').format(element.date!)
            : '';
      } else {
        return DateFormat('dd/MM/yyyy').format(element.createdAt!);
      }
    }

    pw.Widget _buildTableCell(String text,
        {pw.FontWeight? fontWeight, bool isHeader = false}) {
      final color = isHeader ? PdfColors.blue : PdfColors.white;
      final textColor = isHeader ? PdfColors.white : PdfColors.black;
      return pw.Container(
        padding: pw.EdgeInsets.all(8.0),
        alignment: pw.Alignment.center,
        color: color,
        child: pw.Text(
          text,
          style: pw.TextStyle(fontWeight: fontWeight, color: textColor),
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.fromLTRB(20, 20, 20, 0),
        build: (context) => [
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'Informe Personal',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border:
                      pw.TableBorder.all(width: 1.0, color: PdfColors.black),
                  children: <pw.TableRow>[
                    pw.TableRow(
                      children: <pw.Widget>[
                        _buildTableCell('Tipo',
                            fontWeight: pw.FontWeight.bold, isHeader: true),
                        _buildTableCell('Nombre',
                            fontWeight: pw.FontWeight.bold, isHeader: true),
                        _buildTableCell('Descripción',
                            fontWeight: pw.FontWeight.bold, isHeader: true),
                        _buildTableCell('Fecha',
                            fontWeight: pw.FontWeight.bold, isHeader: true),
                      ],
                    ),
                    for (int i = 0; i < filteredElements.length; i++)
                      pw.TableRow(
                        children: <pw.Widget>[
                          _buildTableCell(filteredElements[i].type!,
                              fontWeight: pw.FontWeight.normal),
                          _buildTableCell(filteredElements[i].name,
                              fontWeight: pw.FontWeight.normal),
                          _buildTableCell(filteredElements[i].description,
                              fontWeight: pw.FontWeight.normal),
                          _buildTableCell(_getDateValue(filteredElements[i]),
                              fontWeight: pw.FontWeight.normal),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  return pdf.save();
}

  bool _shouldIncludeElement(ElementData element) {
    if ((_includeEmotion && element.type == 'emotion') ||
        (_includeMood && element.type == 'mood') ||
        (_includeEvent && element.type == 'event')) {
      return element.date != null &&
          element.date!.isAfter(_startDate.subtract(Duration(days: 1))) &&
          element.date!.isBefore(_endDate.add(Duration(days: 1)));
    }
    return false;
  }

  Future<void> _generateAndSendPDF() async {
  try {
    // Generar el PDF
    final Uint8List pdfBytes = await _generateAndSavePDF();

    // Guardar el PDF localmente en el directorio temporal
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String pdfPath = '$tempPath/informe_personal.pdf';
    final File pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);

    // Crear las opciones de correo electrónico con el PDF adjunto
    final MailOptions mailOptions = MailOptions(
      body: 'Mindcare.',
      subject: 'PDF de los informes',
      recipients: [userEmail],
      attachments: [pdfPath],
      isHTML: false,
    );

    // Enviar el correo electrónico con el PDF adjunto
    await FlutterMailer.send(mailOptions);
  } catch (error) {
    print('Error al enviar el correo: $error');
  }
}

  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _updatePdf() {
    setState(() {
      archivoPdf = _generateAndSavePDF();
    });
  }

  void _showNoElementSelectedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selecciona al menos un tipo de elemento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
