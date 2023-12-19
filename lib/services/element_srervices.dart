// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/services/user_services.dart';

class ElementService extends ChangeNotifier {
  static String id_user = '';
  static String type = '';
  static String typeUser = '';
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<ElementData> elements = [];
  final List<ElementData> emotions = [];

  bool isLoading = true;

  Future newElement(
    String id_user,
    String type_user,
    String type,
    String date, {
    int? mood_id,
    int? emotion_id,
    String? description,
  }) async {
    final Map<String, dynamic> elementData = {
      'id_user': id_user,
      'type_user': type_user,
      'type': type,
      'date': date,
    };

    if (mood_id != null) {
      elementData['mood_id'] = mood_id;
    }
    if (description != null) {
      elementData['description'] = description;
    }
    if (emotion_id != null) {
      elementData['emotion_id'] = emotion_id;
    }

    final url = Uri.http(baseURL, '/public/api/newElement', {});
    String? authToken = await readToken();

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(elementData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      ElementService.id_user = decoded['data']['id_user'].toString();
      ElementService.type = decoded['data']['type'].toString();
      return 'success';
    } else {
      return 'error';
    }
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<List<ElementData>> getMoods() async {
    final String token = await readToken();

    final Uri url = Uri.https(baseURL, '/public/api/moods');

    isLoading = true;
    notifyListeners();

    final http.Response resp = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData['success'] == true) {
      for (var data in decodedData['data']) {
        if (data['type'] == 'mood') {
          ElementData elementData = ElementData(
            id: data['id'],
            type: data['type'] ?? '',
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            image: data['image'] ?? '',
            date: data['date'] != null ? DateTime.parse(data['date']) : null,
            createdAt: DateTime.parse(data['created_at']),
          );
          elements.add(elementData);
        }
      }
    }
    isLoading = false;
    notifyListeners();
    return elements;
  }

  Future<List<ElementData>> getEmotions() async {
    final String token = await readToken();

    final Uri url = Uri.https(baseURL, '/public/api/emotions');

    isLoading = true;
    notifyListeners();

    final http.Response resp = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData['success'] == true) {
      for (var data in decodedData['data']) {
        ElementData elementData = ElementData(
          name: data['name'],
          description: data['description'],
          id: data['id'],
          image: data['image'] ?? '',
        );
        emotions.add(elementData);
      }
    }
    isLoading = false;
    notifyListeners();
    return emotions;
  }

  Future<List<ElementData>> getElements() async {
    final String userId = UserService.userId;
    final String token = await readToken();
    final Map<String, String> queryParams = {
      'id': userId,
    };
    final Uri url = Uri.https(baseURL, '/public/api/elements', queryParams);

    isLoading = true;
    notifyListeners();

    final http.Response resp = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData['success'] == true) {
      for (var data in decodedData['data']) {
        ElementData elementData = ElementData(
          id: data['id'],
          type: data['type'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          image: data['image'] ?? '',
          date: data['date'] != null ? DateTime.parse(data['date']) : null,
          createdAt: DateTime.parse(data['created_at']),
        );
        elements.add(elementData);
      }
    }
    isLoading = false;
    notifyListeners();
    return elements;
  }
}
