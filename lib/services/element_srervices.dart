import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/services/user_services.dart';

class ElementService extends ChangeNotifier {
  static String idUser = '';
  static String type = '';
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<ElementData> elements = [];

  bool isLoading = true;

  Future newElement(
    int? emotionId,
    int? moodId,
    String? description,
    String typeUser,
    String idUser,
    String type,
    String date,
  ) async {
    final Map<String, dynamic> elementData = {
      'id_user': idUser,
      'type_user': typeUser,
      'type': type,
      // aqui el tipo date (en un futuro) debemos hacerle un formatter y en register Screen usar este campo
      'date': date,
    };
    if (moodId != null) {
      elementData['mood_id'] = moodId;
    }
    if (moodId != null) {
      elementData['emotion_id'] = emotionId;
    }
    if (description != null) {
      elementData['description'] = description;
    }
    print(elementData);

    final url = Uri.http(baseURL, '/public/api/newElement', {});
    String? authToken = await readToken();

    final response = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(elementData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      ElementService.idUser = decoded['data']['id_user'].toString();
      ElementService.type = decoded['data']['type'].toString();
      return 'success';
    } else {
      return 'error';
    }
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<List<ElementData>> getElements() async {
    final String token = await readToken();
    final Uri url = Uri.http(
        baseURL, '/public/api/elements', {"id": UserService.userId.toString()});

    try {
      isLoading = true;
      notifyListeners();

      final http.Response resp = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (resp.statusCode == 200) {
        elements
            .clear(); // Limpiamos la lista antes de agregar nuevos elementos

        final Map<String, dynamic> decodedData = json.decode(resp.body);
        var elementData = ElementData.fromJson(decodedData);

        // Verificar si elementData.data es null o está vacío antes de agregar elementos
        if (elementData.data != null && elementData.data!.isNotEmpty) {
          elements
              .clear(); // Limpiamos la lista antes de agregar nuevos elementos
          elements.addAll(elementData.data!); // Agregamos todos los elementos
        } else {
          print('El campo "data" está vacío o es nulo.');
        }

        isLoading = false;
        notifyListeners();
        return elements;
      } else {
        // Manejar errores de estado de la solicitud
        print('Error en la solicitud: ${resp.statusCode}');
        throw Exception('Error en la solicitud: ${resp.statusCode}');
      }
    } catch (error) {
      // Manejar otros tipos de errores, como JSON no válido, etc.
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }
}
