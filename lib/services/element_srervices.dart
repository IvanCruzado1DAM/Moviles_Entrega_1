import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/services/user_services.dart';

class ElementService extends ChangeNotifier {
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<ElementData> elements = [];

  bool isLoading = true;

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<List<ElementData>> getElements() async {
    final String token = await readToken();
    final Uri url = Uri.http(baseURL, '/public/api/elements', {"id": UserService.userId.toString()});
   
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
        elements.clear(); // Limpiamos la lista antes de agregar nuevos elementos

        final Map<String, dynamic> decodedData = json.decode(resp.body);
        var elementData = ElementData.fromJson(decodedData);

       // Verificar si elementData.data es null o está vacío antes de agregar elementos
      if (elementData.data != null && elementData.data!.isNotEmpty) {
        elements.clear(); // Limpiamos la lista antes de agregar nuevos elementos
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